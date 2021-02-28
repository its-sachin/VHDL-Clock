entity BinToBCD is
  port (
    binaryIn : in bit_vector(5 downto 0);
    left : out bit_vector(3 downto 0);
    right : out bit_vector(3 downto 0);
  ) ;
end BinToBCD;

architecture BinToBCDa of BinToBCD is

  signal bcd : bit_vector(7 downto 0);
  signal binary : bit_vector(5 downto 0);

begin
  process( binaryIn )
  begin
    binary <= binaryIn;
    for i in 0 to 5 loop
      bcd(7 downto 1) <= bcd(6 downto 0);
      bcd(0) <= binary(5);
      binary(5 downto 0) <= binary(4 downto 0);
      binary(0) <= '0';

      if (i <5 and bcd(3 downto 0) > "0100") then
        bcd(3 downto 0) <= bcd(3 downto 0) + "0011";
      end if;

      if (i <5 and bcd(7 downto 4 ) > "0100" ) then
        bcd(7 downto 4) <= bcd(7 downto 4) + "0011";
      end if;

    end loop;

    left <= bcd(3 downto 0);
    right <= bcd(7 downto 4);

    
  end process ; -- 

end BinToBCDa ; -- BinToBCDa