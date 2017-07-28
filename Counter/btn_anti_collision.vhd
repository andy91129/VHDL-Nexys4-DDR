LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity btn_anti_collision is
  PORT(
    clock     : IN  STD_LOGIC;  --input clock
    btnc  : IN  STD_LOGIC;  --input signal to be debounced
	 sevenseg    : out STD_LOGIC_VECTOR(6 downto 0);
	 an  		  : out STD_LOGIC_VECTOR(7 downto 0));
end btn_anti_collision;

architecture Behavioral of btn_anti_collision is

	 signal prescaler: STD_LOGIC_VECTOR(16 downto 0) := "11000011010100000";
    signal prescaler_counter: STD_LOGIC_VECTOR(16 downto 0) := (others => '0');
    signal counter: STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal r_an: STD_LOGIC_VECTOR(7 downto 0);
	 signal dout: STD_LOGIC_VECTOR(31 downto 0);-- for output

	 signal reg		:STD_LOGIC_VECTOR(3 downto 0);
	 	 
	 signal btn_count_pressed		:STD_LOGIC_VECTOR(31 downto 0);

	 signal i_cnt			:STD_LOGIC_VECTOR(31 downto 0);
	 
BEGIN

	 -- Button(btnc) anti-collision
	 process(clock,btnc)
	 begin
	 
		if(rising_edge (clock))Then 
			if(btnc = '1')Then
				btn_count_pressed <= btn_count_pressed + 1;
				
						if(btn_count_pressed(24)= '1')Then 
							i_cnt <= i_cnt +1;
							btn_count_pressed <= "00000000000000000000000000000000";
						End if;
				
			End if;
		End if;
		

		   
	 end process; 
	 
	 dout <= i_cnt;
	 an <= r_an;

    -- Given Binary Value print it
    process(counter)
    begin
        -- Set anode correctly
        case counter(2 downto 0) is
            when "000" => r_an <= "11111110"; -- AN 0
								reg <= dout(3 downto 0);
            when "001" => r_an <= "11111101"; -- AN 1
								reg <= dout(7 downto 4);
            when "010" => r_an <= "11111011"; -- AN 2
								reg <= dout(11 downto 8);
            when "011" => r_an <= "11110111"; -- AN 3
								reg <= dout(15 downto 12);
				when "100" => r_an <= "11101111"; -- AN 4
								reg <= dout(19 downto 16);
				when "101" => r_an <= "11011111"; -- AN 5
								reg <= dout(23 downto 20);
				when "110" => r_an <= "10111111"; -- AN 6
								reg <= dout(27 downto 24);
				when "111" => r_an <= "01111111"; -- AN 7
								reg <= dout(31 downto 28);

            when others => r_an <= "11111111"; -- nothing
								reg <= "0000"; -- nothing
        end case;
		  
	end process;
	
	process(reg)
	begin
		  -- Set segments correctly
		  case reg is
				when "0000" => sevenseg <= "0000001";--0
				when "0001" => sevenseg <= "1001111";--1
				when "0010" => sevenseg <= "0010010";--2
				when "0011" => sevenseg <= "0000110";--3
				when "0100" => sevenseg <= "1001100";--4
				when "0101" => sevenseg <= "0100100";--5
				when "0110" => sevenseg <= "0100000";--6
				when "0111" => sevenseg <= "0001101";--7
				when "1000" => sevenseg <= "0000000";--8
				when "1001" => sevenseg <= "0000100";--9
				when "1010" => sevenseg <= "0001000";--A
				when "1011" => sevenseg <= "1100000";--B
				when "1100" => sevenseg <= "0110001";--C
				when "1101" => sevenseg <= "1000010";--D
				when "1110" => sevenseg <= "0110000";--E
				when "1111" => sevenseg <= "0111000";--F
				
				when others => sevenseg <= "1111111";--nothing
			end case;
			
    end process;
		
    countClock: process(clock, counter)
    begin
        if rising_edge(clock) then
            prescaler_counter <= prescaler_counter + 1;
            if(prescaler_counter = prescaler) then
                -- Iterate
                counter <= counter + 1;

                prescaler_counter <= (others => '0');
            end if;
        end if;
    end process;
	 
end Behavioral;

