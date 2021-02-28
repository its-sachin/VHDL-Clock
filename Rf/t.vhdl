entity Clock is
  port (
    clock : in bit;
    reset : in bit;
    mode : in bit;

    currOn : out bit_vector(6 downto 0);
    anode : out bit_vector(3 downto 0);

  ) ;
end Clock;

architecture ClockA of Clock is

    signal clr_count : boolean;
    signal clr_sec : boolean;
    signal clr_min : boolean;
    signal clr_hrs : boolean;

    signal count : bit_vector(23 downto 0);
    signal secs : bit_vector(5 downto 0);
    signal mins : bit_vector(5 downto 0);
    signal hrs : bit_vector(4 downto 0);

    signal leftL : bit_vector(6 downto 0);
    signal leftR : bit_vector(6 downto 0);
    signal rightL : bit_vector(6 downto 0);
    signal rightR : bit_vector(6 downto 0);

begin
    process( clock, reset, mode )
    begin
        if (clock = '1' and clock'rising_edge) then

            clr_count <= (count = "100110001001011001111111" );
            clr_sec <= (secs = "111011" );
            clr_min <= (mins = "111011" );
            clr_hrs <= (hrs = "10111" );

            if (reset or clr_count) then
                count <= 0;
                else count <= count + 1;
            end if;

            if (reset or clr_secs) then
                secs <= 0;
            else if (clr_count) then
                secs <= secs + 1;
            end if;

            if (reset or clr_min) then
                mins <= 0;
            else if (clr_secs) then
                mins <= mins + 1;
            end if;

            if (reset or clr_hrs) then
                hrs <= 0;
            else if (clr_min) then
                hrs <= hrs + 1;
            end if;
        
            secBCD : entity work.BinToBCD is
                port map (secs, secL, secR) ;
            
            secLeft : entity work.BinToSs is
                port map (secL, secLss) ;
            
            secRight : entity work.BinToSs is
                port map (secR, secRss) ;



            minBCD : entity work.BinToBCD is
                port map (mins, minL, minR) ;

            minLeft : entity work.BinToSs is
                port map (minL, minLss) ;
            
            minRight : entity work.BinToSs is
                port map (minR, minRss) ;

            

            hrsBCD : entity work.BinToBCD is
                port map (hrs, hrsL, hrsR) ;

            hrsLeft : entity work.BinToSs is
                port map (hrsL, hrsLss) ;
            
            hrsRight : entity work.BinToSs is
                port map (hrsR, hrsRss) ;



            if (mode = '1') then
                leftL <= hrsLss;
                leftR <= hrsRss;

                rightL <= minLss;
                rightR <= minRss;

                else
                    leftL <= minLss;
                    rightR <= minRss;

                    rightL <= secLss;
                    rightR <= secRss;

            end if;



        end if;
            
        
    end process ; -- 

end ClockA ; -- ClockA