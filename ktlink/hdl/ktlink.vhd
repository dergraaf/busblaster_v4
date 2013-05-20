----------------------------------------------------------------------------------
-- Copyright (c) 2013 Fabian Greif
-- 
-- Description: 
-- 
-- KT-LINK compatible buffer description for BusBlaster v4.
-- See http://kristech.eu/sites/default/files/KT-LINK-UM-ENG.pdf for the pin
-- assignment of the FT2232 and the buffer logic.
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel is
   port (
      -- JTAG connector
      trst_np  : inout std_logic;
      tdi_p    : inout std_logic;
      tms_p    : inout std_logic;       -- SWDIO
      tck_p    : inout std_logic;       -- SWCLK
      rtck_p   : in    std_logic;
      tdo_p    : in    std_logic;       -- SWO
      srst_np  : inout std_logic;
      dbgrq_p  : in    std_logic;
      dbgack_p : in    std_logic;

      -- FT2232 connections
      ft_tck_p     : in  std_logic;     -- TCK
      ft_tdi_p     : in  std_logic;     -- TDI
      ft_tdo_p     : out std_logic;     -- TDO
      ft_tms_p     : in  std_logic;     -- TMS
      adbus4_p     : in  std_logic;
      ft_swd_en_np : in  std_logic;     -- SWD enable
      ft_srst_in_p : out std_logic;     -- SRST in
      ft_rtck_p    : out std_logic;     -- RTCK

      ft_trst_p     : in std_logic;     -- TRST
      ft_srst_out_p : in std_logic;     -- SRST out
      ft_trst_oe_np : in std_logic;     -- TRST OE
      ft_srst_oe_np : in std_logic;     -- SRST OE
      ft_tms_oe_np  : in std_logic;     -- TMS OE
      ft_tdi_oe_np  : in std_logic;     -- TDI OE
      ft_tck_oe_np  : in std_logic;     -- TCK OE
      ft_led_np     : in std_logic;     -- LED

      bdbus0_p : in  std_logic;
      ft_rx_p  : out std_logic;         -- RX
      bdbus2_p : in  std_logic;
      bdbus3_p : in  std_logic;
      bdbus4_p : in  std_logic;
      bdbus5_p : in  std_logic;
      bdbus6_p : in  std_logic;
      bdbus7_p : in  std_logic;

      bcbus0_p : in std_logic;
      bcbus1_p : in std_logic;
      bcbus2_p : in std_logic;
      bcbus3_p : in std_logic;
      bcbus4_p : in std_logic;
      bcbus5_p : in std_logic;
      bcbus6_p : in std_logic;
      bcbus7_p : in std_logic;

      -- other
      led_p     : out std_logic;
      button_np : in  std_logic
      );
end toplevel;

architecture behavioral of toplevel is
begin
   tck_p <= ft_tck_p when ft_tck_oe_np = '0' else 'Z';
   tdi_p <= ft_tdi_p when ft_tdi_oe_np = '0' else 'Z';

   process (ft_tms_oe_np, ft_tdi_p, ft_tms_p, ft_swd_en_np, tdo_p, tms_p)
   begin
      if ft_swd_en_np = '0' then
         -- use SWD
         if ft_tms_oe_np = '0' then
            tms_p <= ft_tdi_p;
         else
            tms_p <= 'Z';
         end if;
         ft_tdo_p <= tms_p;
         ft_rx_p  <= tdo_p;
      else
         -- use JTAG
         if ft_tms_oe_np = '0' then
            tms_p <= ft_tms_p;
         else
            tms_p <= 'Z';
         end if;
         ft_tdo_p <= tdo_p;
         ft_rx_p  <= '1';
      end if;
   end process;

   trst_np      <= ft_trst_p     when ft_trst_oe_np = '0' else 'Z';
   srst_np      <= ft_srst_out_p when ft_srst_oe_np = '0' else 'Z';
   ft_srst_in_p <= srst_np;

   ft_rtck_p <= rtck_p;

   led_p <= not ft_led_np;
end behavioral;
