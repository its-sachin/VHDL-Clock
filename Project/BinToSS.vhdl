entity BinToSs is
  port (
    binary : in bit_vector(3 downto 0);
    segment : out bit_vector(6 downto 0);
  ) ;
end BinToSS;



architecture BinToSsA of BinToSs is

begin
    case binary is
        when "0000" => segment <= "1111110";
        when "0001" => segment <= "0110000";
        when "0010" => segment <= "1101101";
        when "0011" => segment <= "1111001";
        when "0100" => segment <= "0110011";
        when "0101" => segment <= "1011011";
        when "0110" => segment <= "1011111";
        when "0111" => segment <= "1110000";
        when "1000" => segment <= "1111111";
        when "1001" => segment <= "1111011";
    end case;

end BinToSsA ; -- BinToSsA