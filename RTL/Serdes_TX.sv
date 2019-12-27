//------------------------------------------------------------------------------
//
//Module Name:					Serdes_TX.v
//Department:					Xidian University
//Function Description:	        8B/10B编码SerDes模块发送端
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana	Verdvana	Verdvana		  			2019-12-24
//
//-----------------------------------------------------------------------------------
//
//Version	Modified History
//V1.0		8位并行数据转1位串行
//          进行8B/10B编码
//          1Gbps
//
//-----------------------------------------------------------------------------------


`timescale 1ns/1ns

module Serdes_TX(
    //********时钟与复位*********//
    input           clk,        //时钟100MHz
    input           clk_hs,        //时钟	
    input           rst_n,      //异步复位
    //*******控制/数据信号*******//
    input           enable,     //使能
    input           k_char,     //控制为1，数据为0
     //********数据输入输出*******//
    input  [7:0]    data_in,    //8bit并行数据输入
    output          data_out,   //1bit串行数据输出
    //**********指示信号*********//
    output          valid       //转换完成
);



    //===================================================================
    //8B/10B编码器

    wire        rd;
    wire [9:0]  data;

    Enc8b10b u_Enc8b10b(
        //********时钟与复位*********//
    	.clk(clk),             //时钟
        .rst_n(rst_n),         //复位
        //*******控制/数据信号*******//
        .enable,                    //使能
        .k_char,                    //控制为1，数据为0
        //***运行不一致性（RD）信号***//
        .init_rd_n(1'b0),           //RD初始化，通常为0
        .init_rd_val(rd),           //RD输入，连接上次转码的RD输出
        .rd,                        //RD输出，连接下次转码的RD输入
        //********数据输入输出*******//
        .data_in,                   //8bit数据输入
        .data_out(data)             //10bit数据输出
    );


    //===================================================================
    //串行器

    Serializer u_Serializer(
        //********时钟与复位*********//
        .clk(clk_hs),              //串行时钟
        .rst_n(rst_n),         //异步复位
        //**********使能信号*********//
        .enable,                    //使能
        //*******数据输出入/输出******//
        .data_in(data),             //10位并行数据输入
        .data_out,                  //1位串行数据输出
        //**********指示信号*********//
        .valid                      //转换完成
    );
   

endmodule