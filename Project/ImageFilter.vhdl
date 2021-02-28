-- @SACHIN
-- 2019CS10722
-- Declaration of originality : complete code written solely by me


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- code that is not given starts from line 88
entity RAM_64Kx8 is
    port (
        clock : in std_logic;
        read_enable, write_enable : in std_logic; -- signals that enable read/write operation
        address : in std_logic_vector(15 downto 0); -- 2^16 = 64K
        data_in : in std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end RAM_64Kx8;


entity ROM_32x9 is
    port (
        clock : in std_logic;
        read_enable : in std_logic; -- signal that enables read operation
        address : in std_logic_vector(4 downto 0); -- 2^5 = 32
        data_out : out std_logic_vector(7 downto 0)
    );
end ROM_32x9;


entity MAC is
    port (
        clock : in std_logic;
        control : in std_logic; -- ‘0’ for initializing the sum
        data_in1, data_in2 : in std_logic_vector(17 downto 0);
        data_out : out std_logic_vector(17 downto 0)
    );
end MAC;

architecture Artix of RAM_64Kx8 is
    type Memory_type is array (0 to 65535) of std_logic_vector (7 downto 0);
    signal Memory_array : Memory_type;
    begin
    process (clock) begin
        if rising_edge (clock) then
            if (read_enable = '1') then -- the data read is available after the clock edge
                data_out <= Memory_array (to_integer (unsigned (address)));
            end if;
            if (write_enable = '1') then -- the data is written on the clock edge
                Memory_array (to_integer (unsigned(address))) <= data_in;
            end if;
        end if;
    end process;
end Artix;


architecture Artix of ROM_32x9 is
    type Memory_type is array (0 to 31) of std_logic_vector (8 downto 0);
    signal Memory_array : Memory_type;
    begin
    process (clock) begin
        if rising_edge (clock) then
            if (read_enable = '1') then -- the data read is available after the clock edge
                data_out <= Memory_array (to_integer (unsigned (address)));
            end if;
        end if;
    end process;
end Artix;


architecture Artix of MAC is
    signal sum, product : signed (17 downto 0);
    begin
        data_out <= std_logic_vector (sum);
        product <= signed (data_in1) * signed (data_in2)
        process (clock) begin
            if rising_edge (clock) then -- sum is available after clock edge
                if (control = '0') then -- initialize the sum with the first product
                    sum <= std_logic_vector (product);
                else -- add product to the previous sum
                    sum <= std_logic_vector (product + signed (sum));
                end if;
            end if;
        end process;
end Artix;

-- given part ends here.
-----------------------------------------------------------------------------------------------------

-- entity for the main functioning of filter
entity overall_design is
    port (
      clock : in std_logic;
      switch : in std_logic; --if 0 smoothen, if 1 sharpen the image
      push : in std_logic -- start filtering if push changes its value.
    ) ;
  end overall_design;


architecture main of overall_design is

    signal source_count : std_logic_vector(15 downto 0); -- index that tells the address of source image (pixel to read at given clock)
    signal edited_count : std_logic_vector(15 downto 0); -- index that tells the address of filtered image (pixel to write at given clock)
    signal i : std_logic_vector(4 downto 0);  -- index that tells the address of coefficient (coeffecient multiplied at given clock)
    signal diff : integer;  -- int value that is to be added to source_count to get the exact address
    signal edited : std_logic_vector(7 down to 0);  -- stores the pixel value that is to be wrriten in filtered image at address edited_count
    signal done : bit;  -- 0 while the process of filter is going on, 1 if image is filered
    signal prev_push : bit; -- stores the value of push in previous clock
    signal sumOn : bit; -- 0 if new summation to start, remains 1 if summation process of X[L+i,J+j]*C[i,j] is going on.

begin

    -- instance of ROM giving coeff (a 9 bit vector) as output that is value of coefficient matrix at given i.
    rom : entity work.ROM_32x9(Artix)
    port map (clock, 1, i, coeff) ; 

    -- instance of RAM that reads source image pixcel at index source_count + i + diff and produces source (a 8 bit vector) as output i.e. pixel value of source image.
    ramRead : entity work.RAM_64Kx8(Artix)
    port map (clock, 1,0, std_logic_vector(to_unsigned(to_integer(unsigned(source_count) + to_integer(unsigned(i))) + diff, 16)), edited, source);

    -- instance of RAM that writes the pixel value (i.e. "edited") of filtered image at index edited_count and gives no output.
    -- sum+done+1 is 1 when sum and done both are 0 or both are 1, both are 1 is not possible (as filter done and summation still on is not possible) 
    -- hence write only when sum = 0 and done = 0 (i.e. when filter process is going on and summation of X[L+i,J+j]*C[i,j] is done)
    ramWrite : entity work.RAM_64Kx8(Artix)
    port map (clock, 0,sumOn+done+1, edited_count, edited, nill);

    -- instance of MAC that performs multiplication of X[L+i,J+j]*C[i,j] 
    multiply : entity work.MAC(Artix)
    port map (clock, sumOn, std_logic_vector(to_signed(to_integer(unsigned(source), 18))), std_logic_vector(to_signed(to_integer(signed(coeff), 18))), sum)

    process( clock)
    begin
        if (rising_edge(clock)) then

            -- push value is changd, start filtering the image.
            if (prev_push /= push) then
                done = 0;
                source_count <= std_logic_vector(unsigned(161), 16)));
                edited_count <= std_logic_vector(unsigned(32768), 16)));
                prev_push <= push;
                if (switch = 0) then
                    i <= 0;
                    else i <= "10000";
                end if;
            end if;
            
            -- now doing the filter.
            if (done = 0) then

                -- max value of i reached i.e. summation X[L+i,J+k]*C[i,j] is done
                if (to_integer(unsigned(i)) = 9 or to_integer(unsigned(i)) = 25) then

                    -- reached the max value of source_count i.e. filter process is done.
                    if (to_integer(unsigned(source_count)) = 19039) then
                        done <= 1;
                        sumOn <= 0;

                    -- filter is not done yet
                    else 

                        -- reached at boundary of source matrix => then increase source_count by 3.
                        if (((to_integer(unsigned(source_count)) + 2) mod 160) = 0) then
                            source_count <= std_logic_vector(to_unsigned(to_integer(unsigned(source_count) + 3, 16)));
                        
                            -- else increase source_count by 1
                            else 
                            source_count <= std_logic_vector(to_unsigned(to_integer(unsigned(source_count) + 1, 16)));
                        end if;

                    end if;

                    edited_count <= std_logic_vector(to_unsigned(to_integer(unsigned(edited_count) + 1, 16)));

                    -- initialise next summation
                    i <= 0;
                    sumOn <= 0;

                    -- if sum is -ve set it to 0 otherwise right shift 7 bits.
                    if (sum(17) = 1) then
                        edited <= 0;

                        else
                            edited <= sum(14 down to 7);
                    end if;

                -- update value of diff depending on value of i (described in detail in pdf)
                else 
                    if (to_integer(unsigned(i)) <= 2) then
                        diff <= -161;
                    end if;
                    
                    if (to_integer(unsigned(i)) >= 3 and to_integer(unsigned(i)) <= 5) then
                        diff <= -4;
                    end if;

                    if (to_integer(unsigned(i)) >= 6 and to_integer(unsigned(i)) <= 8) then
                        diff <= 153;
                    end if;

                    if (to_integer(unsigned(i)) >= 16 and to_integer(unsigned(i)) <= 18) then
                        diff <= -177;
                    end if;

                    if (to_integer(unsigned(i)) >= 19 and to_integer(unsigned(i)) <= 21) then
                        diff <= -20;
                    end if;

                    if (to_integer(unsigned(i)) >= 22 and to_integer(unsigned(i)) <= 24) then
                        diff <= 137;
                    end if;

                    sumOn <= 1;
                    i <= i + 1;

                end if;
            end if;

        
    end process ; -- 

end main ; -- main