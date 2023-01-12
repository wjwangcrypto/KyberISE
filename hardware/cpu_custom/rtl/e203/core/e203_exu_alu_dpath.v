 /*                                                                      
 Copyright 2018 Nuclei System Technology, Inc.                
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
  Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */                                                                      
                                                                         
                                                                         
                                                                         
//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  This module to implement the datapath of ALU
//
// ====================================================================
`include "e203_defines.v"

module e203_exu_alu_dpath(

  //////////////////////////////////////////////////////
  // ALU request the datapath
  input  alu_req_alu,

  input  alu_req_alu_add ,
  input  alu_req_alu_sub ,
  input  alu_req_alu_xor ,
  input  alu_req_alu_sll ,
  input  alu_req_alu_srl ,
  input  alu_req_alu_sra ,
  input  alu_req_alu_or  ,
  input  alu_req_alu_and ,
  input  alu_req_alu_slt ,
  input  alu_req_alu_sltu,
  input  alu_req_alu_lui ,
  input  alu_req_alu_lqwl,
  input  alu_req_alu_ibutterfly,
  input  alu_req_alu_nswapll,
  input  alu_req_alu_nswaphl,
  input  alu_req_alu_nswaplh,
  input  alu_req_alu_nswaphh,
  input  [`E203_XLEN-1:0] alu_req_alu_op1,
  input  [`E203_XLEN-1:0] alu_req_alu_op2,
  output [`E203_XLEN-1:0] alu_req_alu_res,

  //////////////////////////////////////////////////////
  // BJP request the datapath
  input  bjp_req_alu,

  input  [`E203_XLEN-1:0] bjp_req_alu_op1,
  input  [`E203_XLEN-1:0] bjp_req_alu_op2,
  input  bjp_req_alu_cmp_eq ,
  input  bjp_req_alu_cmp_ne ,
  input  bjp_req_alu_cmp_lt ,
  input  bjp_req_alu_cmp_gt ,
  input  bjp_req_alu_cmp_ltu,
  input  bjp_req_alu_cmp_gtu,
  input  bjp_req_alu_add,

  output bjp_req_alu_cmp_res,
  output [`E203_XLEN-1:0] bjp_req_alu_add_res,

  //////////////////////////////////////////////////////
  // AGU request the datapath
  input  agu_req_alu,

  input  [`E203_XLEN-1:0] agu_req_alu_op1,
  input  [`E203_XLEN-1:0] agu_req_alu_op2,
  input  agu_req_alu_swap,
  input  agu_req_alu_add ,
  input  agu_req_alu_and ,
  input  agu_req_alu_or  ,
  input  agu_req_alu_xor ,
  input  agu_req_alu_max ,
  input  agu_req_alu_min ,
  input  agu_req_alu_maxu,
  input  agu_req_alu_minu,

  output [`E203_XLEN-1:0] agu_req_alu_res,

  input  agu_sbf_0_ena,
  input  [`E203_XLEN-1:0] agu_sbf_0_nxt,
  output [`E203_XLEN-1:0] agu_sbf_0_r,

  input  agu_sbf_1_ena,
  input  [`E203_XLEN-1:0] agu_sbf_1_nxt,
  output [`E203_XLEN-1:0] agu_sbf_1_r,

`ifdef E203_SUPPORT_SHARE_MULDIV //{
  //////////////////////////////////////////////////////
  // MULDIV request the datapath
  input  muldiv_req_alu,

  input  [`E203_ALU_ADDER_WIDTH-1:0] muldiv_req_alu_op1,
  input  [`E203_ALU_ADDER_WIDTH-1:0] muldiv_req_alu_op2,
  input                              muldiv_req_alu_add ,
  input                              muldiv_req_alu_sub ,
  output [`E203_ALU_ADDER_WIDTH-1:0] muldiv_req_alu_res,

  input           muldiv_sbf_0_ena,
  input  [33-1:0] muldiv_sbf_0_nxt,
  output [33-1:0] muldiv_sbf_0_r,

  input           muldiv_sbf_1_ena,
  input  [33-1:0] muldiv_sbf_1_nxt,
  output [33-1:0] muldiv_sbf_1_r,
`endif//E203_SUPPORT_SHARE_MULDIV}

  ////////////////////////////////////////////
  //ibutterfly_instructions
  ////////////////////////////////////////////
  output [`E203_XLEN-1:0] ibutterfly_mul_req_op1,
  output [`E203_XLEN-1:0] ibutterfly_mul_req_op2,
  output ibutterfly_mul_req,
  input [63:0] ibutterfly_c_return,
  

  input  clk,
  input  rst_n
  );
  
  `ifdef E203_XLEN_IS_32
      // This is the correct config since E200 is 32bits core
  `else
      !!! ERROR: There must be something wrong, our core must be 32bits wide !!!
  `endif

  wire [`E203_XLEN-1:0] mux_op1;
  wire [`E203_XLEN-1:0] mux_op2;

  wire [`E203_XLEN-1:0] misc_op1 = mux_op1[`E203_XLEN-1:0];
  wire [`E203_XLEN-1:0] misc_op2 = mux_op2[`E203_XLEN-1:0];

  // Only the regular ALU use shifter
  wire [`E203_XLEN-1:0] shifter_op1 = alu_req_alu_op1[`E203_XLEN-1:0];
  wire [`E203_XLEN-1:0] shifter_op2 = alu_req_alu_op2[`E203_XLEN-1:0];

  wire op_max;  
  wire op_min ; 
  wire op_maxu;
  wire op_minu;

  wire op_add;
  wire op_sub;
  wire op_addsub = op_add | op_sub; 

  wire op_or;
  wire op_xor;
  wire op_and;

  wire op_sll;
  wire op_srl;
  wire op_sra;

  wire op_slt;
  wire op_sltu;

  wire op_mvop2;


  wire op_cmp_eq ;
  wire op_cmp_ne ;
  wire op_cmp_lt ;
  wire op_cmp_gt ;
  wire op_cmp_ltu;
  wire op_cmp_gtu;

  wire cmp_res;

  wire sbf_0_ena;
  wire [33-1:0] sbf_0_nxt;
  wire [33-1:0] sbf_0_r;

  wire sbf_1_ena;
  wire [33-1:0] sbf_1_nxt;
  wire [33-1:0] sbf_1_r;
  
  

  wire [12:0] kred_res;
  //////////////////////////////////////////////////////////////
  ////IBUTTERFLY_implement
  //////////////////////////////////////////////////////////////
  wire op_ibutterfly = alu_req_alu_ibutterfly;
  wire [`E203_XLEN-1:0] ibf_op1;
  wire [11:0] ibf_op2;
  wire [11:0] ibf_req_kred_a;
  wire [11:0] ibf_req_kred_t;
  wire [11:0] ibf_a;
  wire [11:0] ibf_b;
  wire [12:0] ibf_addres_tmp;
  wire [11:0] ibf_add_res;
  wire [12:0] ibf_sub_res_tmp;
  wire [11:0] ibf_sub_res;
  wire [12:0] ibf_cmp; ////////////////////////////////////////////////////////////[11->12]
  wire [12:0] ibf_c_cmp;
  wire [11:0] ibf_c;
  wire [`E203_XLEN-1:0] ibf_res;
  assign ibutterfly_mul_req = op_ibutterfly ? 1'b1 : 1'b0;
  assign ibf_op1 = {`E203_XLEN{op_ibutterfly}} & misc_op1;
  assign ibf_op2 = {`E203_XLEN{op_ibutterfly}} & misc_op2[11:0];
  assign ibf_a = ibf_op1[11:0];
  assign ibf_b = ibf_op1[27:16];
  assign ibf_addres_tmp = ibf_a + ibf_b;
  assign ibf_cmp = ibf_addres_tmp - 3329;
  assign ibf_add_res = ibf_cmp[12] ? ibf_addres_tmp : ibf_cmp;
  assign ibf_sub_res_tmp =  ibf_a - ibf_b;
  assign ibf_sub_res = ibf_sub_res_tmp[12] ? ibf_sub_res_tmp + 3329 : ibf_sub_res_tmp;

  
  assign ibf_req_kred_a = ibf_sub_res;
  //assign kred_a = {`E203_XLEN{op_ibutterfly}} & {{16{ibf_sub_res[15]}},ibf_sub_res};
  assign ibf_req_kred_t = ibf_op2;
  assign ibf_c_cmp = kred_res + 3329;
  assign ibf_c = kred_res[12] ? ibf_c_cmp[11:0] : kred_res[11:0];
  assign ibf_res = {{4'b0,ibf_c},{4'b0,ibf_add_res}};
  
 
  

  
   /////////////////////////////////////////////////////////
  /// 2kred_implement
  /////////////////////////////////////////////////////////
  wire [11:0] kred_a;
  wire [11:0] kred_t;
  wire [24:0] kred_mul_res;
  wire [7:0] kred_c0_tmp;
  wire [16:0] kred_c1_tmp;
  wire [12:0] kred_mul_tmp;
  wire [16:0] kred_mul_tmp1;
  wire [16:0] kred_c_tmp;
  wire [3:0] kred_c0;
  wire [12:0] kred_c1;
  //wire [8:0] kred_mul_kc0_tmp;
  wire [12:0] kred_mul_kc0;
  wire [12:0] kred_res_tmp;
  
  
  
  assign kred_a = ibf_req_kred_a ;
  assign kred_t = ibf_req_kred_t ;
  //assign ibutterfly_mul_req_op1 = kred_a + 3329;
  assign ibutterfly_mul_req_op1 = kred_a; 
  assign ibutterfly_mul_req_op2 = kred_t;

  
  assign kred_mul_res = ibutterfly_c_return[24:0];
  assign kred_c0_tmp = kred_mul_res[7:0];
  assign kred_c1_tmp = kred_mul_res[24:8];
  assign kred_mul_tmp = kred_c0_tmp * (-13);
  assign kred_mul_tmp1 = {{4{kred_mul_tmp[12]}},kred_mul_tmp};
  assign kred_c_tmp = kred_mul_tmp1 + kred_c1_tmp;
  assign kred_c0 = kred_c_tmp[3:0];
  assign kred_c1 = kred_c_tmp[16:4];
  //assign kred_mul_kc0_tmp = kred_c0 * (-13);
  //assign kred_mul_kc0 = {kred_mul_kc0_tmp,4'b0};
  assign kred_mul_kc0 = kred_c0 * (-208);
  assign kred_res_tmp = kred_mul_kc0 + kred_c1;
  assign kred_res = kred_res_tmp[12:0];
  
  
  
  ////////////////////////////////////////////////////////////////////////////
  // Impelment swap instructions
  //
  ////////////////////////////////////////////////////////////////////////////
  wire op_nswapll = alu_req_alu_nswapll;
  wire op_nswaphl = alu_req_alu_nswaphl;
  wire op_nswaplh = alu_req_alu_nswaplh;
  wire op_nswaphh = alu_req_alu_nswaphh;
  wire op_swap = op_nswapll | op_nswaphl | op_nswaplh | op_nswaphh;
  wire [`E203_XLEN-1:0] swap_op1;
  wire [`E203_XLEN-1:0] swap_op2;
  wire [`E203_XLEN-1:0] nswapll_res;
  wire [`E203_XLEN-1:0] nswaphl_res;
  wire [`E203_XLEN-1:0] nswaplh_res;
  wire [`E203_XLEN-1:0] nswaphh_res;
  
  assign swap_op1 = {`E203_XLEN{op_swap}} & misc_op1;
  assign swap_op2 = {`E203_XLEN{op_swap}} & misc_op2;
  assign nswapll_res = {swap_op1[15:0],swap_op2[15:0]};
  assign nswaphl_res = {swap_op1[31:16],swap_op2[15:0]};
  assign nswaplh_res = {swap_op1[15:0],swap_op2[31:16]};
  assign nswaphh_res = {swap_op1[31:16],swap_op2[31:16]};
  
  
  //////////////////////////////////////////////////////////////
  // Impelment the Left-Shifter
  //
  // The Left-Shifter will be used to handle the shift op
  wire [`E203_XLEN-1:0] shifter_in1;
  wire [5-1:0] shifter_in2;
  wire [`E203_XLEN-1:0] shifter_res;


  wire op_shift = op_sra | op_sll | op_srl; 
  
     // Make sure to use logic-gating to gateoff the 
  assign shifter_in1 = {`E203_XLEN{op_shift}} &
          //   In order to save area and just use one left-shifter, we
          //   convert the right-shift op into left-shift operation
           (
               (op_sra | op_srl) ? 
                 {
    shifter_op1[00],shifter_op1[01],shifter_op1[02],shifter_op1[03],
    shifter_op1[04],shifter_op1[05],shifter_op1[06],shifter_op1[07],
    shifter_op1[08],shifter_op1[09],shifter_op1[10],shifter_op1[11],
    shifter_op1[12],shifter_op1[13],shifter_op1[14],shifter_op1[15],
    shifter_op1[16],shifter_op1[17],shifter_op1[18],shifter_op1[19],
    shifter_op1[20],shifter_op1[21],shifter_op1[22],shifter_op1[23],
    shifter_op1[24],shifter_op1[25],shifter_op1[26],shifter_op1[27],
    shifter_op1[28],shifter_op1[29],shifter_op1[30],shifter_op1[31]
                 } : shifter_op1
           );
  assign shifter_in2 = {5{op_shift}} & shifter_op2[4:0];

  assign shifter_res = (shifter_in1 << shifter_in2);

  wire [`E203_XLEN-1:0] sll_res = shifter_res;
  wire [`E203_XLEN-1:0] srl_res =  
                 {
    shifter_res[00],shifter_res[01],shifter_res[02],shifter_res[03],
    shifter_res[04],shifter_res[05],shifter_res[06],shifter_res[07],
    shifter_res[08],shifter_res[09],shifter_res[10],shifter_res[11],
    shifter_res[12],shifter_res[13],shifter_res[14],shifter_res[15],
    shifter_res[16],shifter_res[17],shifter_res[18],shifter_res[19],
    shifter_res[20],shifter_res[21],shifter_res[22],shifter_res[23],
    shifter_res[24],shifter_res[25],shifter_res[26],shifter_res[27],
    shifter_res[28],shifter_res[29],shifter_res[30],shifter_res[31]
                 };
  
  wire [`E203_XLEN-1:0] eff_mask = (~(`E203_XLEN'b0)) >> shifter_in2;
  wire [`E203_XLEN-1:0] sra_res =
               (srl_res & eff_mask) | ({32{shifter_op1[31]}} & (~eff_mask));



  //////////////////////////////////////////////////////////////
  // Impelment the Adder
  //
  // The Adder will be reused to handle the add/sub/compare op

     // Only the MULDIV request ALU-adder with 35bits operand with sign extended 
     // already, all other unit request ALU-adder with 32bits opereand without sign extended
     //   For non-MULDIV operands
  wire op_unsigned = op_sltu | op_cmp_ltu | op_cmp_gtu | op_maxu | op_minu;
  wire [`E203_ALU_ADDER_WIDTH-1:0] misc_adder_op1 =
      {{`E203_ALU_ADDER_WIDTH-`E203_XLEN{(~op_unsigned) & misc_op1[`E203_XLEN-1]}},misc_op1};
  wire [`E203_ALU_ADDER_WIDTH-1:0] misc_adder_op2 =
      {{`E203_ALU_ADDER_WIDTH-`E203_XLEN{(~op_unsigned) & misc_op2[`E203_XLEN-1]}},misc_op2};


  wire [`E203_ALU_ADDER_WIDTH-1:0] adder_op1 = 
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_req_alu_op1 :
`endif//E203_SUPPORT_SHARE_MULDIV}
      misc_adder_op1;
  wire [`E203_ALU_ADDER_WIDTH-1:0] adder_op2 = 
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_req_alu_op2 :
`endif//E203_SUPPORT_SHARE_MULDIV}
      misc_adder_op2;

  wire adder_cin;
  wire [`E203_ALU_ADDER_WIDTH-1:0] adder_in1;
  wire [`E203_ALU_ADDER_WIDTH-1:0] adder_in2;
  wire [`E203_ALU_ADDER_WIDTH-1:0] adder_res;

  wire adder_add;
  wire adder_sub;

  assign adder_add =
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_req_alu_add :
`endif//E203_SUPPORT_SHARE_MULDIV}
      op_add; 
  assign adder_sub =
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_req_alu_sub :
`endif//E203_SUPPORT_SHARE_MULDIV}
               (
                   // The original sub instruction
               (op_sub) 
                   // The compare lt or gt instruction
             | (op_cmp_lt | op_cmp_gt | 
                op_cmp_ltu | op_cmp_gtu |
                op_max | op_maxu |
                op_min | op_minu |
                op_slt | op_sltu 
               ));

  wire adder_addsub = adder_add | adder_sub; 
  

     // Make sure to use logic-gating to gateoff the 
  assign adder_in1 = {`E203_ALU_ADDER_WIDTH{adder_addsub}} & (adder_op1);
  assign adder_in2 = {`E203_ALU_ADDER_WIDTH{adder_addsub}} & (adder_sub ? (~adder_op2) : adder_op2);
  assign adder_cin = adder_addsub & adder_sub;

  assign adder_res = adder_in1 + adder_in2 + adder_cin;



  //////////////////////////////////////////////////////////////
  // Impelment the XOR-er
  //
  // The XOR-er will be reused to handle the XOR and compare op

  wire [`E203_XLEN-1:0] xorer_in1;
  wire [`E203_XLEN-1:0] xorer_in2;

  wire xorer_op = 
               op_xor
                   // The compare eq or ne instruction
             | (op_cmp_eq | op_cmp_ne); 

     // Make sure to use logic-gating to gateoff the 
  assign xorer_in1 = {`E203_XLEN{xorer_op}} & misc_op1;
  assign xorer_in2 = {`E203_XLEN{xorer_op}} & misc_op2;

  wire [`E203_XLEN-1:0] xorer_res = xorer_in1 ^ xorer_in2;
     // The OR and AND is too light-weight, so no need to gate off
  wire [`E203_XLEN-1:0] orer_res  = misc_op1 | misc_op2; 
  wire [`E203_XLEN-1:0] ander_res = misc_op1 & misc_op2; 


  //////////////////////////////////////////////////////////////
  // Generate the CMP operation result
       // It is Non-Equal if the XOR result have any bit non-zero
  wire neq  = (|xorer_res); 
  wire cmp_res_ne  = (op_cmp_ne  & neq);
       // It is Equal if it is not Non-Equal
  wire cmp_res_eq  = op_cmp_eq  & (~neq);
       // It is Less-Than if the adder result is negative
  wire cmp_res_lt  = op_cmp_lt  & adder_res[`E203_XLEN];
  wire cmp_res_ltu = op_cmp_ltu & adder_res[`E203_XLEN];
       // It is Greater-Than if the adder result is postive
  wire op1_gt_op2  = (~adder_res[`E203_XLEN]);
  wire cmp_res_gt  = op_cmp_gt  & op1_gt_op2;
  wire cmp_res_gtu = op_cmp_gtu & op1_gt_op2;

  assign cmp_res = cmp_res_eq 
                 | cmp_res_ne 
                 | cmp_res_lt 
                 | cmp_res_gt  
                 | cmp_res_ltu 
                 | cmp_res_gtu; 

  //////////////////////////////////////////////////////////////
  // Generate the mvop2 result
  //   Just directly use op2 since the op2 will be the immediate
  wire [`E203_XLEN-1:0] mvop2_res = misc_op2;

  //////////////////////////////////////////////////////////////
  // Generate the SLT and SLTU result
  //   Just directly use op2 since the op2 will be the immediate
  wire op_slttu = (op_slt | op_sltu);
  //   The SLT and SLTU is reusing the adder to do the comparasion
       // It is Less-Than if the adder result is negative
  wire slttu_cmp_lt = op_slttu & adder_res[`E203_XLEN];
  wire [`E203_XLEN-1:0] slttu_res = 
               slttu_cmp_lt ?
               `E203_XLEN'b1 : `E203_XLEN'b0;

  //////////////////////////////////////////////////////////////
  // Generate the Max/Min result
  wire maxmin_sel_op1 =  ((op_max | op_maxu) &   op1_gt_op2) 
                      |  ((op_min | op_minu) & (~op1_gt_op2));

  wire [`E203_XLEN-1:0] maxmin_res  = maxmin_sel_op1 ? misc_op1 : misc_op2;  

  //////////////////////////////////////////////////////////////
  // Generate the final result
  wire [`E203_XLEN-1:0] alu_dpath_res = 
        ({`E203_XLEN{op_or       }} & orer_res )
      | ({`E203_XLEN{op_and      }} & ander_res)
      | ({`E203_XLEN{op_xor      }} & xorer_res)
      | ({`E203_XLEN{op_addsub   }} & adder_res[`E203_XLEN-1:0])
      | ({`E203_XLEN{op_srl      }} & srl_res)
      | ({`E203_XLEN{op_sll      }} & sll_res)
      | ({`E203_XLEN{op_sra      }} & sra_res)
      | ({`E203_XLEN{op_mvop2    }} & mvop2_res)
      | ({`E203_XLEN{op_slttu    }} & slttu_res)
      | ({`E203_XLEN{op_max | op_maxu | op_min | op_minu}} & maxmin_res)
	  | ({`E203_XLEN{op_ibutterfly}} & ibf_res)
	  | ({`E203_XLEN{op_nswapll  }} & nswapll_res)
	  | ({`E203_XLEN{op_nswaplh  }} & nswaplh_res)
	  | ({`E203_XLEN{op_nswaphl  }} & nswaphl_res)
	  | ({`E203_XLEN{op_nswaphh  }} & nswaphh_res)
        ;

  //////////////////////////////////////////////////////////////
  // Implement the SBF: Shared Buffers
  sirv_gnrl_dffl #(33) sbf_0_dffl (sbf_0_ena, sbf_0_nxt, sbf_0_r, clk);
  sirv_gnrl_dffl #(33) sbf_1_dffl (sbf_1_ena, sbf_1_nxt, sbf_1_r, clk);

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  //  The ALU-Datapath Mux for the requestors 

  localparam DPATH_MUX_WIDTH = ((`E203_XLEN*2)+21);

  assign  {
     mux_op1
    ,mux_op2
    ,op_max  
    ,op_min  
    ,op_maxu 
    ,op_minu 
    ,op_add
    ,op_sub
    ,op_or
    ,op_xor
    ,op_and
    ,op_sll
    ,op_srl
    ,op_sra
    ,op_slt
    ,op_sltu
    ,op_mvop2
    ,op_cmp_eq 
    ,op_cmp_ne 
    ,op_cmp_lt 
    ,op_cmp_gt 
    ,op_cmp_ltu
    ,op_cmp_gtu
    }
    = 
        ({DPATH_MUX_WIDTH{alu_req_alu}} & {
             alu_req_alu_op1
            ,alu_req_alu_op2
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,alu_req_alu_add
            ,alu_req_alu_sub
            ,alu_req_alu_or
            ,alu_req_alu_xor
            ,alu_req_alu_and
            ,alu_req_alu_sll
            ,alu_req_alu_srl
            ,alu_req_alu_sra
            ,alu_req_alu_slt
            ,alu_req_alu_sltu
            ,alu_req_alu_lui// LUI just move-Op2 operation
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
        })
      | ({DPATH_MUX_WIDTH{bjp_req_alu}} & {
             bjp_req_alu_op1
            ,bjp_req_alu_op2
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,bjp_req_alu_add
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,bjp_req_alu_cmp_eq 
            ,bjp_req_alu_cmp_ne 
            ,bjp_req_alu_cmp_lt 
            ,bjp_req_alu_cmp_gt 
            ,bjp_req_alu_cmp_ltu
            ,bjp_req_alu_cmp_gtu

        })
      | ({DPATH_MUX_WIDTH{agu_req_alu}} & {
             agu_req_alu_op1
            ,agu_req_alu_op2
            ,agu_req_alu_max  
            ,agu_req_alu_min  
            ,agu_req_alu_maxu 
            ,agu_req_alu_minu 
            ,agu_req_alu_add
            ,1'b0
            ,agu_req_alu_or
            ,agu_req_alu_xor
            ,agu_req_alu_and
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,agu_req_alu_swap// SWAP just move-Op2 operation
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
        })
        ;
        
  assign alu_req_alu_res     = alu_dpath_res[`E203_XLEN-1:0];
  assign agu_req_alu_res     = alu_dpath_res[`E203_XLEN-1:0];
  assign bjp_req_alu_add_res = alu_dpath_res[`E203_XLEN-1:0];
  assign bjp_req_alu_cmp_res = cmp_res;
`ifdef E203_SUPPORT_SHARE_MULDIV //{
  assign muldiv_req_alu_res  = adder_res;
`endif//E203_SUPPORT_SHARE_MULDIV}

  assign sbf_0_ena = 
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_sbf_0_ena : 
`endif//E203_SUPPORT_SHARE_MULDIV}
                 agu_sbf_0_ena;
  assign sbf_1_ena = 
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_sbf_1_ena : 
`endif//E203_SUPPORT_SHARE_MULDIV}
                 agu_sbf_1_ena;

  assign sbf_0_nxt = 
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_sbf_0_nxt : 
`endif//E203_SUPPORT_SHARE_MULDIV}
                 {1'b0,agu_sbf_0_nxt};
  assign sbf_1_nxt = 
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_sbf_1_nxt : 
`endif//E203_SUPPORT_SHARE_MULDIV}
                 {1'b0,agu_sbf_1_nxt};

  assign agu_sbf_0_r = sbf_0_r[`E203_XLEN-1:0];
  assign agu_sbf_1_r = sbf_1_r[`E203_XLEN-1:0];

`ifdef E203_SUPPORT_SHARE_MULDIV //{
  assign muldiv_sbf_0_r = sbf_0_r;
  assign muldiv_sbf_1_r = sbf_1_r;
`endif//E203_SUPPORT_SHARE_MULDIV}

endmodule                                      
                                               
                                               
                                               
