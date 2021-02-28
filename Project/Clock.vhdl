-- Sachin
-- 2019CS10722
-- COL215 Assignment 1
-- Declaration of originality - all code written solely by me



-- entity of BinToSs that will provide seven segement representation of given number
entity BinToSs is
  port (
    binary : in bit_vector(3 downto 0);
    segment : out bit_vector(6 downto 0)
  ) ;
end BinToSS;


-- architecture of BinToSs where seven segment representation is matched to all possible input.
architecture BinToSsA of BinToSs is

begin
    with binary select
        segment <= "1111110" when "0000"; -- for binary = 0
        segment <= "0110000" when "0001"; -- for binary = 1
        segment <= "1101101" when "0010"; -- for binary = 2
        segment <= "1111001" when "0011"; -- for binary = 3
        segment <= "0110011" when "0100"; -- for binary = 4
        segment <= "1011011" when "0101"; -- for binary = 5
        segment <= "1011111" when "0110"; -- for binary = 6
        segment <= "1110000" when "0111"; -- for binary = 7
        segment <= "1111111" when "1000"; -- for binary = 8
        segment <= "1111011" when "1001"; -- for binary = 9

end BinToSsA ; -- BinToSsA



-- entity of BinToBCD that will provide BCD of given number
entity BinToBCD is

  port (
    binaryIn : in bit_vector(5 downto 0);
    left : out bit_vector(3 downto 0);
    right : out bit_vector(3 downto 0)
  ) ;
end BinToBCD;

-- architecture of BinToBCD using double dabble method
architecture BinToBCDa of BinToBCD is

-- using bcd to store both digits in one vector and binary so that no changes are done on input binaryIn
  signal bcd : bit_vector(7 downto 0);
  signal binary : bit_vector(5 downto 0);

begin
  process( binaryIn )
  begin
    binary <= binaryIn;

    -- initialising loop on vector on number of bits in number
    for i in 0 to 5 loop
      bcd(7 downto 1) <= bcd(6 downto 0);
      bcd(0) <= binary(5);
      binary(5 downto 0) <= binary(4 downto 0);
      binary(0) <= '0';

    --   add 3 to first digit if first digit is more than 4
      if (i <5 and bcd(3 downto 0) > "0100") then
        bcd(3 downto 0) <= bcd(3 downto 0) + "0011";
      end if;

      --   add 3 to second digit if second digit is more than 4
      if (i <5 and bcd(7 downto 4 ) > "0100" ) then
        bcd(7 downto 4) <= bcd(7 downto 4) + "0011";
      end if;

    end loop;

    -- first 4 bits represent left bit and last 4 number represent right bit
    left <= bcd(3 downto 0);
    right <= bcd(7 downto 4);

    
  end process ; -- 

end BinToBCDa ; -- BinToBCDa




-- entity of main funtioning block of whole assignment
entity Clock is
  port (
    clock : in bit;
    enable : in bit;
    reset : in bit;
    mode : in bit;
    toChange : in bit;
    inc : in bit;

    currOn : out bit_vector(7 downto 0);
    anode : out bit_vector(3 downto 0)

  ) ;
end Clock;

-- architecture of clock, complete functioning done here
architecture ClockA of Clock is

    -- several signals used for convinience usage of all described in pdf.
    signal clr_count : boolean;
    signal clr_sec : boolean;
    signal clr_min : boolean;
    signal clr_hrs : boolean;

    signal count : bit_vector(26 downto 0);
    signal secs : bit_vector(5 downto 0);
    signal mins : bit_vector(5 downto 0);
    signal hrs : bit_vector(4 downto 0);

    signal dCount : bit_vector(31 downto 0);

    signal leftL : bit_vector(6 downto 0);
    signal leftR : bit_vector(6 downto 0);
    signal rightL : bit_vector(6 downto 0);
    signal rightR : bit_vector(6 downto 0);

    signal place : bit_vector(1 downto 0);
    signal iCound : bit_vector(24 downto 0);
    signal thresold : bit_vector(27 downto 0);
    signal clr_iCount : boolean;
    signal notOnce : boolean;

begin
    process(clock, enable, reset, inc)
    begin
        -- perform changes on clock rising edge and enable is 1.
        if (enable = '1' and clock = '1' and clock'rising_edge) then

            --check if count reaches its max value 99,999,999
            clr_count <= (count = "101111101011110000011111111" ); 
            --check if secs reaches its max value 59
            clr_sec <= clr_count and (secs = "111011" );
            --check if mins reaches its max value 59
            clr_min <= clr_sec and (mins = "111011" );
            --check if hrs reaches its max value 23
            clr_hrs <= clr_min and (hrs = "10111" );

            -- set to 0 if count reaches max or clock is reset
            if (reset = '1' or clr_count) then
                count <= 0;
                else count <= count + 1;
            end if;

            -- set to 0 if secs reaches max or clock is reset else increase every 1s.
            if (reset = '1' or clr_secs) then
                secs <= 0;
            elsif (clr_count) then
                secs <= secs + 1;
            end if;

            -- set to 0 if mins reaches max or clock is reset else increase every 1min.
            if (reset = '1' or clr_min) then
                mins <= 0;
            elsif (clr_secs) then
                mins <= mins + 1;
            end if;

            -- set to 0 if hrs reaches max or clock is reset else increase every 1hour.
            if (reset = '1' or clr_hrs) then
                hrs <= 0;
            elsif (clr_min) then
                hrs <= hrs + 1;
            end if;

            -- set to 0 if clock is reset else increase every clock pulse.
            if (reset = '1') then
                dCount <= 0;
                else dCount <= dCount + 1;
            end if;

            --check if iCount reaches its max value 20,000,000;
            clr_iCount <= (iCount = "1001100010010110100000000");

            -- set to 0 if iCount reaches max or clock is reset or inc is set 0 else increase every clock pulse.
            if (reset = '1' or inc = '0' or clr_iCount) then
                iCount <= 0;
                else iCount <= iCount +1;
            end if;

            -- set to 0 if clock is reset or inc is set 0 else increase every clock pulse till reaches its max .
            if (reset = '1' or inc = '0') then
                thresold <= 0;
            elsif (thresold(27) = '0') then
                thresold <= thresold +1;
            end if;

            --set notOnce to true if inc is made 1.
            if (inc = '0') then notOnce <= true;
            end if;

        end if;
            
        
    end process ; -- 
    
    process(enable, mode, secs, mins, hrs, dCount)
    begin
        -- perform changes only when enable is 1.
        if (enable = '1') then
            -- secs to individual digits to seven segment representation of those digits
            secBCD : entity work.BinToBCD(BinToBCDa)
                port map (secs, secL, secR) ;
            
            secLeft : entity work.BinToSs(BinToSsA)
                port map (secL, secLss) ;
            
            secRight : entity work.BinToSs(BinToSsA)
                port map (secR, secRss) ;


            -- mins to individual digits to seven segment representation of those digits
            minBCD : entity work.BinToBCD(BinToBCDa)
                port map (mins, minL, minR) ;

            minLeft : entity work.BinToSs(BinToSsA)
                port map (minL, minLss) ;
            
            minRight : entity work.BinToSs(BinToSsA)
                port map (minR, minRss) ;

            
            -- hrs to individual digits to seven segment representation of those digits
            hrsBCD : entity work.BinToBCD(BinToBCDa)
                port map ('0' & hrs(4 down to 0), hrsL, hrsR) ;

            hrsLeft : entity work.BinToSs(BinToSsA)
                port map (hrsL, hrsLss) ;
            
            hrsRight : entity work.BinToSs(BinToSsA)
                port map (hrsR, hrsRss) ;


            -- set to hh:mm mode if mode is 1 else mm:ss mode
            if (mode = '1') then
                leftL <= hrsLss;
                leftR <= hrsRss;

                rightL <= minLss;
                rightR <= minRss;

                else
                    leftL <= minLss;
                    leftR <= minRss;

                    rightL <= secLss;
                    rightR <= secRss;

            end if;
            
            -- setting the output currOn and anode to one of the digit every 10ms
            case dCount(19 down to 18) is
                when "00" => currOn <= leftL & '0'; anode <= "1110";
                -- decimal of second digit always remains on so as to distinguish between hh to mm or mm to ss
                when "01" => currOn <= leftR & '1'; anode <= "1101";
                when "10" => currOn <= rightL & '0'; anode <= "1011";
                -- decimal of least significant digit blinks every second
                when others currOn <= rightR & secs(0); anode <= "0111";

            end case;

        -- if enable is 0 then output is off, no display is on
        else
            currOn <= 0;
            anode <= "1111";


        end if;

        
    end process ; -- 

    process(enable, toChange, inc, mode, clr_iCount, thresold)
    begin
        -- increment only if clock is on
        if (enable = '1') then

            -- working of toChange, it only changes place(digit position that is to be changed)
            if (toChange = '1') then
                place <= place +1;
            end if;

            -- increase digits when if condition is true(explained in detail in pdf)  
            if ((inc = '1' and notOnce)or (clr_iCount and thresold(27) = '1') then

                -- distinguishing every digit using case statement as bound of all is different
                case place is

                    -- changing most significant digit 
                    when "11" =>

                        -- when maximum is reached(i.e. 2 in hh:mm mode and 5 in mm:ss mode) set it back to 0 else increse by 1
                        if ((mode = '1' and leftL = "0010") or (mode = '0' and leftL = "0101")) then
                            leftL <= "0000";
                        else leftL <= leftL + 1;
                        end if;
                        
                    -- changing second most significant digit 
                    when "10" =>

                        -- when maximum is reached(i.e. 3 in hh:mm mode and 9 in mm:ss mode) set it back to 0 else increse by 1
                        if ((mode = '1' and leftR = "0011") or (mode = '1' and leftR = "1001")) then
                            leftR <= "0000";
                        else leftR <= leftR+ 1;
                        end if;

                    -- changing second least significant digit 
                    when "01" => 

                        -- when maximum is reached(i.e. 5 in both modes) else increase by 1
                        if (rightL = "0101") then
                            rightL <= "0000";
                        else rightL <= rightL + 1;
                        end if;

                    -- changing least significant digit 
                    when "00" =>

                        -- when maximum is reached(i.e. 9 in both modes) else increase by 1
                        if (rightR = "1001") then
                            rightR <= "0000";
                        else rightR <= rightR + 1;
                        end if;
                    
                end case;
                -- once increased setting notOnce to false
                notOnce <= false;
            end if;

        end if;
                
        
    end process ; -- 
    

end ClockA ; -- ClockA