`timescale 1ns / 1ps

module clock_d(input main_clk, output slow_clk);
	reg [31:0] counter;
	
	always @ (posedge main_clk)
	begin
		counter <= counter + 1;	
	end
	
	assign slow_clk = counter[27];
endmodule

module division (input enable, input [7:0] divisor,input [7:0] dividend,output reg [7:0] quotient, output reg [7:0] remainder);

// Variables
integer i;
reg [7:0] divisor_reg, dividend_reg;
reg [7:0] storage;

always @(divisor or dividend or enable)
begin
    if (~enable) 
    begin
        quotient = 8'b00000000;
        remainder = 8'b00000000;
    end 
    else 
    begin 
        divisor_reg = divisor;
        dividend_reg = dividend;
        storage = 8'b00000000; 
        for (i = 0; i < 8; i = i + 1) begin
            storage = {storage[6:0], dividend_reg[7]};
            dividend_reg[7:1] = dividend_reg[6:0];
            storage = storage - divisor_reg;
            if (storage[7] == 1) begin
                dividend_reg[0] = 0;
                storage = storage + divisor_reg;
            end
            else begin
                dividend_reg[0] = 1;
            end
        end
     
    quotient = dividend_reg;
    remainder = dividend - (divisor_reg * dividend_reg);
    end
end

endmodule


module Register_File(input mode,input [3:0] index_write,[3:0] index_read,input [7:0] write_data,output reg [7:0] Data);
    reg [7:0] register_file [15:0]; // R0 to R15
    integer i;
    
    initial 
    begin      
                register_file[0] = 0;
                register_file[1] = 2;
                register_file[2] = 135;
                register_file[3] = 6;
                register_file[4] = 204;
                register_file[5] = 246;
                register_file[6] = 83;
                register_file[7] = 7;
                register_file[8] = 77;
                register_file[9] = 198;
                register_file[10] = 111;
                register_file[11] = 128;
                register_file[12] = 127;
                register_file[13] = 130;
                register_file[14] = 147;
                register_file[15] = 20;
            
    end 
    
    always @(*)
    begin
            if (mode == 0) begin
                Data = register_file[index_read]; // Read
            end else begin
                register_file[index_write] = write_data; // Write
            end
        end

endmodule



module Instruction_File(input [3:0] index , output [7:0] Instruction) ;
    reg [7:0] Instruction_Set[6:0] ;  
    
    initial
    begin
Instruction_Set[0] = 8'b10010001; // Load R1 in accumulator
Instruction_Set[1] = 8'b01100001; // Clear accumulator
Instruction_Set[2] = 8'b10010011; // Load R3 in accumulator  
Instruction_Set[3] = 8'b10000001; // LLS
Instruction_Set[4] = 8'b10100001; // multiply accumulator with R3
Instruction_Set[5] = 8'b10110000; // Increment
Instruction_Set[6] = 8'b11111111; // Halt
    end 
    
    assign Instruction = Instruction_Set[index] ; 

endmodule 
     

module Processor (input [7:0] instruction , input [7:0] operand , input [7:0] accumulator , output reg [15:0] result);
reg enable ;
wire [7:0]r, q;
initial begin 
    enable = 0 ; 
end 
division div (enable, operand, accumulator,q, r);
    always @(*)
    begin
        case(instruction[7:4])
            4'b0001: result = operand + accumulator; // ADD
            4'b0010: result = accumulator - operand; // SUB
            4'b0011: result = operand * accumulator; // MUL
            //4'b0100: enable = 1; // DIV | need to change
            4'b0000: begin   if (instruction[3:0] == 4'b0001) result = accumulator << 1; // LSL
                        else if (instruction[3:0] == 4'b0010) result = accumulator >> 1; // LSR
                        else if (instruction[3:0] == 4'b0011) result = {accumulator[0], accumulator[7:1]}; // CIR
                        else if (instruction[3:0] == 4'b0100) result = {accumulator[6:0], accumulator[7]}; // CIL
                        else if (instruction[3:0] == 4'b0101) result = {accumulator[7], accumulator[7:1]}; // ASR
                        else if (instruction[3:0] == 4'b0110) result = accumulator + 1; // INCREMENT
                        else if (instruction[3:0] == 4'b0111) result = accumulator -1 ; // DECREMENT
                    end
            4'b0101: result = operand & accumulator; // AND
            4'b0110: result = operand ^ accumulator; // XOR
            4'b0111: begin // CMP
                        if (accumulator >= operand) result = 0;
                        else result = 1;
                     end
            4'b1001: result = operand; //MOV ACC Ri
            4'b1010: result = instruction[3:0]; // MOV Ri ACC
            default: result = 0; // Default behavior when no instruction matches
        endcase
        
        if (instruction[7:4] == 4'b0100)
        begin 
            enable = 1 ;
            result[15:8] = r ; 
            result[7:0] = q ; 
        end  
        else enable = 0 ; 
    end
endmodule


module Control_Unit(input main_clk,input[3:0] Indexing, output reg[7:0]  accumulator, output [7:0]regis); 
//    reg [7:0] accumulator ;
    reg [7:0] extra_register ;
    reg cb ; 
    reg [3:0] current_address ;
    wire [7:0] instruction ;
    wire [7:0] operand;
    wire [15:0] result;
    reg mode ; 
    reg [3:0]index_write ;
    wire clk ; 
//    clock_d RA(main_clk,clk) ;
	initial begin cb = 1; end
    initial begin
        current_address = 0 ;
        mode = 0 ; 
    end
    
    Processor Processor_inst(.instruction(instruction),.operand(operand),.accumulator(accumulator),.result(result));
    Instruction_File Instruction_File_inst(current_address,instruction) ; 
    Register_File Register_File_inst(mode,index_write,instruction[3:0],accumulator,operand) ;
    Register_File pls(mode,index_write,Indexing,accumulator,regis) ;
    
     always @(posedge main_clk) begin
//Accum = accumulator ;
        if (instruction == 8'b11111111) begin end // HALT
        else begin
            //might update branch address
            //ins = instructs[curr_address];
            if (instruction[7:4] == 4'b1010) mode = 1 ; 
               else mode = 0 ;
            case(instruction[7:4])
                4'b0001: {cb, accumulator} = result; // ADD
                4'b0010: {cb, accumulator} = result; // SUB
                4'b0011: {extra_register, accumulator} = result; // MUL
                4'b0100: {extra_register, accumulator} = result; // DIV | need to change
                4'b0000: begin  if (instruction[3:0] == 4'b0001) accumulator = result; // LSL
                                else if (instruction[3:0] == 4'b0010) accumulator = result; // LSR
                                else if (instruction[3:0] == 4'b0011) accumulator = result; // CIR
                                else if (instruction[3:0] == 4'b0100) accumulator = result; // CIL
                                else if (instruction[3:0] == 4'b0101) accumulator = result; // ASR
                                else if (instruction[3:0] == 4'b0110) {cb, accumulator} = result; // INCREMENT
                                else if (instruction[3:0] == 4'b0111) {cb, accumulator} = result; // DECREMENT
                        end
                4'b0101: accumulator = result; // AND
                4'b0110: accumulator = result; // XOR
                4'b0111: begin // CMP
                            if (accumulator >= operand) cb = result;
                            else cb = result;
                         end
                4'b1001: accumulator = result; //MOV ACC Ri
                4'b1010: index_write = result ;
                4'b1000: if (cb == 1) begin
                            //branch_address = curr_address; 
                            current_address = instruction[3:0];  //BRANCH
                            current_address = current_address - 1;
                            //branch_flag = 1;
                            end
                4'b1011: current_address = instruction[3:0] - 1; //RETURN
                default: begin end
               endcase
               
               current_address = current_address + 1 ;
//               assign Accum = accumulator ;
            end
    end

endmodule