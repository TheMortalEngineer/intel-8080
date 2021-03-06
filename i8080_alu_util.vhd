-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

package i8080_alu_util is
--	function "+"(left, right: std_logic_vector(7 downto 0)) return std_logic_vector;
--	function "+"(left: std_logic_vector(7 downto 0); right: std_logic)
--		return std_logic_vector;

	function get_carry(lhs, rhs, res: std_logic_vector(7 downto 0))
		return std_logic;
	function get_carry(lhs, rhs: std_logic_vector(7 downto 0); res: signed(7 downto 0))
		return std_logic;
	function get_carry(lhs, rhs, res: signed(7 downto 0))
		return std_logic;
	function get_carry(lhs, rhs, res: unsigned(7 downto 0))
		return std_logic;

	function get_aux_carry(lhs, rhs, res: std_logic_vector(7 downto 0))
		return std_logic;
	function get_aux_carry(lhs, rhs: std_logic_vector(7 downto 0); res: signed(7 downto 0))
		return std_logic;
	function get_aux_carry(lhs, rhs, res: signed(7 downto 0))
		return std_logic;
	function get_aux_carry(lhs, rhs, res: unsigned(7 downto 0))
		return std_logic;

	function get_sign(a: std_logic_vector(7 downto 0)) return std_logic;
	function get_zero(a: std_logic_vector(7 downto 0)) return std_logic;
	function get_parity(a: std_logic_vector(7 downto 0)) return std_logic;

end package;

package body i8080_alu_util is
	function get_sign(a: std_logic_vector(7 downto 0)) return std_logic is
	begin
		return a(7);
	end function;
	
	function get_zero(a: std_logic_vector(7 downto 0)) return std_logic is
	begin
		for i in a'range loop
			if a(i) = '1' then
				return '0';
			end if;
		end loop;
		
		return '1';
	end function;
	
	function get_parity(a: std_logic_vector(7 downto 0)) return std_logic is
		variable bitcount: natural range 0 to 8;
	begin
		for i in a'range loop
			if a(i) = '1' then
				bitcount := bitcount + 1;
			end if;
		end loop;
		
		if bitcount mod 2 = 0 then
			return '1';
		else
			return '0';
		end if;
	end function;


	function "+"(left, right: std_logic_vector(7 downto 0)) return std_logic_vector is
		variable ret: std_logic_vector(7 downto 0) := X"00";
	begin
		ret := std_logic_vector(unsigned(left) + unsigned(right));
		return ret;
	end function;

	function "+"(left: std_logic_vector(7 downto 0); right: std_logic)
		return std_logic_vector
	is
		variable right_slv: std_logic_vector(7 downto 0) := X"00";
		variable ret: std_logic_vector(7 downto 0) := X"00";
	begin
		right_slv(7 downto 1) := (others => '0');
		right_slv(0) := right;
		
		ret := std_logic_vector(unsigned(left) + unsigned(right_slv));
		return ret;
	end function;
	
	
	function get_carry_bitwise(lhs, rhs, res: std_logic) return std_logic is
		variable lr: std_logic_vector(1 downto 0) := "00";
		variable ret: std_logic := '0';
	begin
		lr := lhs & rhs;
		case lr is
			when "00" =>
				ret := '0';
				
			when "01"|"10" =>
				if res = '1' then
					ret := '0';
				elsif ret = '0' then
					ret := '1';
				else
					assert false report "get_carry(): ret is invalid value"
						severity Failure;
				end if;
			
			when "11" =>
				ret := '1';
			
			when others =>
				assert false report "get_carry: lhs/rhs is/are invalid value(s)"
					severity Failure;
		end case;
		
		return ret;
	end function;
	
	function get_carry(lhs, rhs, res: std_logic_vector(7 downto 0)) return std_logic is
	begin
		return get_carry_bitwise(lhs(7), rhs(7), res(7));
	end function;

	function get_carry(lhs, rhs: std_logic_vector(7 downto 0); res: signed(7 downto 0))
		return std_logic is
	begin
		return get_carry_bitwise(lhs(7), rhs(7), res(7));
	end function;

	function get_carry(lhs, rhs, res: signed(7 downto 0))
		return std_logic is
	begin
		return get_carry_bitwise(lhs(7), rhs(7), res(7));
	end function;

	function get_carry(lhs, rhs, res: unsigned(7 downto 0))
		return std_logic is
	begin
		return get_carry_bitwise(lhs(7), rhs(7), res(7));
	end function;

	
	function get_aux_carry(lhs, rhs, res: std_logic_vector(7 downto 0)) return std_logic is
	begin
		return get_carry_bitwise(lhs(3), rhs(3), res(3));
	end function;

	function get_aux_carry(lhs, rhs: std_logic_vector(7 downto 0);
		res: signed(7 downto 0)) return std_logic is
	begin
		return get_carry_bitwise(lhs(3), rhs(3), res(3));
	end function;

	function get_aux_carry(lhs, rhs, res: signed(7 downto 0)) return std_logic is
	begin
		return get_carry_bitwise(lhs(3), rhs(3), res(3));
	end function;

	function get_aux_carry(lhs, rhs, res: unsigned(7 downto 0)) return std_logic is
	begin
		return get_carry_bitwise(lhs(3), rhs(3), res(3));
	end function;

end package body;
