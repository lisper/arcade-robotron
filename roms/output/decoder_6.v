// From mame/robotron/decoder.6
 
module decoder_6 (
        input [8:0] address,
        output reg [7:0] data);

  always @(*)
    case (address)
        9'b000000000: // 0
            data = 8'b00000000; // 0
        9'b000000001: // 1
            data = 8'b00000000; // 0
        9'b000000010: // 2
            data = 8'b00000001; // 1
        9'b000000011: // 3
            data = 8'b00000010; // 2
        9'b000000100: // 4
            data = 8'b00000011; // 3
        9'b000000101: // 5
            data = 8'b00000100; // 4
        9'b000000110: // 6
            data = 8'b00000101; // 5
        9'b000000111: // 7
            data = 8'b00000110; // 6
        9'b000001000: // 8
            data = 8'b00000111; // 7
        9'b000001001: // 9
            data = 8'b00001000; // 8
        9'b000001010: // a
            data = 8'b00001001; // 9
        9'b000001011: // b
            data = 8'b00001010; // a
        9'b000001100: // c
            data = 8'b00001011; // b
        9'b000001101: // d
            data = 8'b00001100; // c
        9'b000001110: // e
            data = 8'b00001101; // d
        9'b000001111: // f
            data = 8'b00001110; // e
        9'b000010000: // 10
            data = 8'b00001111; // f
        9'b000010001: // 11
            data = 8'b00010000; // 10
        9'b000010010: // 12
            data = 8'b00010001; // 11
        9'b000010011: // 13
            data = 8'b00010010; // 12
        9'b000010100: // 14
            data = 8'b00010011; // 13
        9'b000010101: // 15
            data = 8'b00010100; // 14
        9'b000010110: // 16
            data = 8'b00010101; // 15
        9'b000010111: // 17
            data = 8'b00010110; // 16
        9'b000011000: // 18
            data = 8'b00010111; // 17
        9'b000011001: // 19
            data = 8'b00011000; // 18
        9'b000011010: // 1a
            data = 8'b00011001; // 19
        9'b000011011: // 1b
            data = 8'b00011010; // 1a
        9'b000011100: // 1c
            data = 8'b00011011; // 1b
        9'b000011101: // 1d
            data = 8'b00011100; // 1c
        9'b000011110: // 1e
            data = 8'b00011101; // 1d
        9'b000011111: // 1f
            data = 8'b00011110; // 1e
        9'b000100000: // 20
            data = 8'b00011111; // 1f
        9'b000100001: // 21
            data = 8'b00100000; // 20
        9'b000100010: // 22
            data = 8'b00100001; // 21
        9'b000100011: // 23
            data = 8'b00100010; // 22
        9'b000100100: // 24
            data = 8'b00100011; // 23
        9'b000100101: // 25
            data = 8'b00100100; // 24
        9'b000100110: // 26
            data = 8'b00100101; // 25
        9'b000100111: // 27
            data = 8'b00100110; // 26
        9'b000101000: // 28
            data = 8'b00100111; // 27
        9'b000101001: // 29
            data = 8'b00101000; // 28
        9'b000101010: // 2a
            data = 8'b00101001; // 29
        9'b000101011: // 2b
            data = 8'b00101010; // 2a
        9'b000101100: // 2c
            data = 8'b00101011; // 2b
        9'b000101101: // 2d
            data = 8'b00101100; // 2c
        9'b000101110: // 2e
            data = 8'b00101101; // 2d
        9'b000101111: // 2f
            data = 8'b00101110; // 2e
        9'b000110000: // 30
            data = 8'b00101111; // 2f
        9'b000110001: // 31
            data = 8'b00110000; // 30
        9'b000110010: // 32
            data = 8'b00110001; // 31
        9'b000110011: // 33
            data = 8'b00110010; // 32
        9'b000110100: // 34
            data = 8'b00110011; // 33
        9'b000110101: // 35
            data = 8'b00110100; // 34
        9'b000110110: // 36
            data = 8'b00110101; // 35
        9'b000110111: // 37
            data = 8'b00110110; // 36
        9'b000111000: // 38
            data = 8'b00110111; // 37
        9'b000111001: // 39
            data = 8'b00111000; // 38
        9'b000111010: // 3a
            data = 8'b00111001; // 39
        9'b000111011: // 3b
            data = 8'b00111010; // 3a
        9'b000111100: // 3c
            data = 8'b00111011; // 3b
        9'b000111101: // 3d
            data = 8'b00111100; // 3c
        9'b000111110: // 3e
            data = 8'b00111101; // 3d
        9'b000111111: // 3f
            data = 8'b00111110; // 3e
        9'b001000000: // 40
            data = 8'b00111111; // 3f
        9'b001000001: // 41
            data = 8'b01000000; // 40
        9'b001000010: // 42
            data = 8'b01000001; // 41
        9'b001000011: // 43
            data = 8'b01000010; // 42
        9'b001000100: // 44
            data = 8'b01000011; // 43
        9'b001000101: // 45
            data = 8'b01000100; // 44
        9'b001000110: // 46
            data = 8'b01000101; // 45
        9'b001000111: // 47
            data = 8'b01000110; // 46
        9'b001001000: // 48
            data = 8'b01000111; // 47
        9'b001001001: // 49
            data = 8'b01001000; // 48
        9'b001001010: // 4a
            data = 8'b01001001; // 49
        9'b001001011: // 4b
            data = 8'b01001010; // 4a
        9'b001001100: // 4c
            data = 8'b01001011; // 4b
        9'b001001101: // 4d
            data = 8'b01001100; // 4c
        9'b001001110: // 4e
            data = 8'b01001101; // 4d
        9'b001001111: // 4f
            data = 8'b01001110; // 4e
        9'b001010000: // 50
            data = 8'b01001111; // 4f
        9'b001010001: // 51
            data = 8'b01010000; // 50
        9'b001010010: // 52
            data = 8'b01010001; // 51
        9'b001010011: // 53
            data = 8'b01010010; // 52
        9'b001010100: // 54
            data = 8'b01010011; // 53
        9'b001010101: // 55
            data = 8'b01010100; // 54
        9'b001010110: // 56
            data = 8'b01010101; // 55
        9'b001010111: // 57
            data = 8'b01010110; // 56
        9'b001011000: // 58
            data = 8'b01010111; // 57
        9'b001011001: // 59
            data = 8'b01011000; // 58
        9'b001011010: // 5a
            data = 8'b01011001; // 59
        9'b001011011: // 5b
            data = 8'b01011010; // 5a
        9'b001011100: // 5c
            data = 8'b01011011; // 5b
        9'b001011101: // 5d
            data = 8'b01011100; // 5c
        9'b001011110: // 5e
            data = 8'b01011101; // 5d
        9'b001011111: // 5f
            data = 8'b01011110; // 5e
        9'b001100000: // 60
            data = 8'b01011111; // 5f
        9'b001100001: // 61
            data = 8'b01100000; // 60
        9'b001100010: // 62
            data = 8'b01100001; // 61
        9'b001100011: // 63
            data = 8'b01100010; // 62
        9'b001100100: // 64
            data = 8'b01100011; // 63
        9'b001100101: // 65
            data = 8'b01100100; // 64
        9'b001100110: // 66
            data = 8'b01100101; // 65
        9'b001100111: // 67
            data = 8'b01100110; // 66
        9'b001101000: // 68
            data = 8'b01100111; // 67
        9'b001101001: // 69
            data = 8'b01101000; // 68
        9'b001101010: // 6a
            data = 8'b01101001; // 69
        9'b001101011: // 6b
            data = 8'b01101010; // 6a
        9'b001101100: // 6c
            data = 8'b01101011; // 6b
        9'b001101101: // 6d
            data = 8'b01101100; // 6c
        9'b001101110: // 6e
            data = 8'b01101101; // 6d
        9'b001101111: // 6f
            data = 8'b01101110; // 6e
        9'b001110000: // 70
            data = 8'b01101111; // 6f
        9'b001110001: // 71
            data = 8'b01110000; // 70
        9'b001110010: // 72
            data = 8'b01110001; // 71
        9'b001110011: // 73
            data = 8'b01110010; // 72
        9'b001110100: // 74
            data = 8'b01110011; // 73
        9'b001110101: // 75
            data = 8'b01110100; // 74
        9'b001110110: // 76
            data = 8'b01110101; // 75
        9'b001110111: // 77
            data = 8'b01110110; // 76
        9'b001111000: // 78
            data = 8'b01110111; // 77
        9'b001111001: // 79
            data = 8'b01111000; // 78
        9'b001111010: // 7a
            data = 8'b01111001; // 79
        9'b001111011: // 7b
            data = 8'b01111010; // 7a
        9'b001111100: // 7c
            data = 8'b01111011; // 7b
        9'b001111101: // 7d
            data = 8'b01111100; // 7c
        9'b001111110: // 7e
            data = 8'b01111101; // 7d
        9'b001111111: // 7f
            data = 8'b01111110; // 7e
        9'b010000000: // 80
            data = 8'b01111111; // 7f
        9'b010000001: // 81
            data = 8'b10000000; // 80
        9'b010000010: // 82
            data = 8'b10000001; // 81
        9'b010000011: // 83
            data = 8'b10000010; // 82
        9'b010000100: // 84
            data = 8'b10000011; // 83
        9'b010000101: // 85
            data = 8'b10000100; // 84
        9'b010000110: // 86
            data = 8'b10000101; // 85
        9'b010000111: // 87
            data = 8'b10000110; // 86
        9'b010001000: // 88
            data = 8'b10000111; // 87
        9'b010001001: // 89
            data = 8'b10001000; // 88
        9'b010001010: // 8a
            data = 8'b10001001; // 89
        9'b010001011: // 8b
            data = 8'b10001010; // 8a
        9'b010001100: // 8c
            data = 8'b10001011; // 8b
        9'b010001101: // 8d
            data = 8'b10001100; // 8c
        9'b010001110: // 8e
            data = 8'b10001101; // 8d
        9'b010001111: // 8f
            data = 8'b10001110; // 8e
        9'b010010000: // 90
            data = 8'b10001111; // 8f
        9'b010010001: // 91
            data = 8'b10010000; // 90
        9'b010010010: // 92
            data = 8'b10010001; // 91
        9'b010010011: // 93
            data = 8'b10010010; // 92
        9'b010010100: // 94
            data = 8'b10010011; // 93
        9'b010010101: // 95
            data = 8'b10010100; // 94
        9'b010010110: // 96
            data = 8'b10010101; // 95
        9'b010010111: // 97
            data = 8'b10010110; // 96
        9'b010011000: // 98
            data = 8'b10010111; // 97
        9'b010011001: // 99
            data = 8'b10011000; // 98
        9'b010011010: // 9a
            data = 8'b10011001; // 99
        9'b010011011: // 9b
            data = 8'b10011010; // 9a
        9'b010011100: // 9c
            data = 8'b10011011; // 9b
        9'b010011101: // 9d
            data = 8'b10011100; // 9c
        9'b010011110: // 9e
            data = 8'b10011101; // 9d
        9'b010011111: // 9f
            data = 8'b10011110; // 9e
        9'b010100000: // a0
            data = 8'b10011111; // 9f
        9'b010100001: // a1
            data = 8'b10100000; // a0
        9'b010100010: // a2
            data = 8'b10100001; // a1
        9'b010100011: // a3
            data = 8'b10100010; // a2
        9'b010100100: // a4
            data = 8'b10100011; // a3
        9'b010100101: // a5
            data = 8'b10100100; // a4
        9'b010100110: // a6
            data = 8'b10100101; // a5
        9'b010100111: // a7
            data = 8'b10100110; // a6
        9'b010101000: // a8
            data = 8'b10100111; // a7
        9'b010101001: // a9
            data = 8'b10101000; // a8
        9'b010101010: // aa
            data = 8'b10101001; // a9
        9'b010101011: // ab
            data = 8'b10101010; // aa
        9'b010101100: // ac
            data = 8'b10101011; // ab
        9'b010101101: // ad
            data = 8'b10101100; // ac
        9'b010101110: // ae
            data = 8'b10101101; // ad
        9'b010101111: // af
            data = 8'b10101110; // ae
        9'b010110000: // b0
            data = 8'b10101111; // af
        9'b010110001: // b1
            data = 8'b10110000; // b0
        9'b010110010: // b2
            data = 8'b10110001; // b1
        9'b010110011: // b3
            data = 8'b10110010; // b2
        9'b010110100: // b4
            data = 8'b10110011; // b3
        9'b010110101: // b5
            data = 8'b10110100; // b4
        9'b010110110: // b6
            data = 8'b10110101; // b5
        9'b010110111: // b7
            data = 8'b10110110; // b6
        9'b010111000: // b8
            data = 8'b10110111; // b7
        9'b010111001: // b9
            data = 8'b10111000; // b8
        9'b010111010: // ba
            data = 8'b10111001; // b9
        9'b010111011: // bb
            data = 8'b10111010; // ba
        9'b010111100: // bc
            data = 8'b10111011; // bb
        9'b010111101: // bd
            data = 8'b10111100; // bc
        9'b010111110: // be
            data = 8'b10111101; // bd
        9'b010111111: // bf
            data = 8'b10111110; // be
        9'b011000000: // c0
            data = 8'b10111111; // bf
        9'b011000001: // c1
            data = 8'b11000000; // c0
        9'b011000010: // c2
            data = 8'b11000001; // c1
        9'b011000011: // c3
            data = 8'b11000010; // c2
        9'b011000100: // c4
            data = 8'b11000011; // c3
        9'b011000101: // c5
            data = 8'b11000100; // c4
        9'b011000110: // c6
            data = 8'b11000101; // c5
        9'b011000111: // c7
            data = 8'b11000110; // c6
        9'b011001000: // c8
            data = 8'b11000111; // c7
        9'b011001001: // c9
            data = 8'b11001000; // c8
        9'b011001010: // ca
            data = 8'b11001001; // c9
        9'b011001011: // cb
            data = 8'b11001010; // ca
        9'b011001100: // cc
            data = 8'b11001011; // cb
        9'b011001101: // cd
            data = 8'b11001100; // cc
        9'b011001110: // ce
            data = 8'b11001101; // cd
        9'b011001111: // cf
            data = 8'b11001110; // ce
        9'b011010000: // d0
            data = 8'b11001111; // cf
        9'b011010001: // d1
            data = 8'b11010000; // d0
        9'b011010010: // d2
            data = 8'b11010001; // d1
        9'b011010011: // d3
            data = 8'b11010010; // d2
        9'b011010100: // d4
            data = 8'b11010011; // d3
        9'b011010101: // d5
            data = 8'b11010100; // d4
        9'b011010110: // d6
            data = 8'b11010101; // d5
        9'b011010111: // d7
            data = 8'b11010110; // d6
        9'b011011000: // d8
            data = 8'b11010111; // d7
        9'b011011001: // d9
            data = 8'b11011000; // d8
        9'b011011010: // da
            data = 8'b11011001; // d9
        9'b011011011: // db
            data = 8'b11011010; // da
        9'b011011100: // dc
            data = 8'b11011011; // db
        9'b011011101: // dd
            data = 8'b11011100; // dc
        9'b011011110: // de
            data = 8'b11011101; // dd
        9'b011011111: // df
            data = 8'b11011110; // de
        9'b011100000: // e0
            data = 8'b11011111; // df
        9'b011100001: // e1
            data = 8'b11100000; // e0
        9'b011100010: // e2
            data = 8'b11100001; // e1
        9'b011100011: // e3
            data = 8'b11100010; // e2
        9'b011100100: // e4
            data = 8'b11100011; // e3
        9'b011100101: // e5
            data = 8'b11100100; // e4
        9'b011100110: // e6
            data = 8'b11100101; // e5
        9'b011100111: // e7
            data = 8'b11100110; // e6
        9'b011101000: // e8
            data = 8'b11100111; // e7
        9'b011101001: // e9
            data = 8'b11101000; // e8
        9'b011101010: // ea
            data = 8'b11101001; // e9
        9'b011101011: // eb
            data = 8'b11101010; // ea
        9'b011101100: // ec
            data = 8'b11101011; // eb
        9'b011101101: // ed
            data = 8'b11101100; // ec
        9'b011101110: // ee
            data = 8'b11101101; // ed
        9'b011101111: // ef
            data = 8'b11101110; // ee
        9'b011110000: // f0
            data = 8'b11101111; // ef
        9'b011110001: // f1
            data = 8'b11110000; // f0
        9'b011110010: // f2
            data = 8'b11110001; // f1
        9'b011110011: // f3
            data = 8'b11110010; // f2
        9'b011110100: // f4
            data = 8'b11110011; // f3
        9'b011110101: // f5
            data = 8'b11110100; // f4
        9'b011110110: // f6
            data = 8'b11110101; // f5
        9'b011110111: // f7
            data = 8'b11110110; // f6
        9'b011111000: // f8
            data = 8'b11110111; // f7
        9'b011111001: // f9
            data = 8'b00000000; // 0
        9'b011111010: // fa
            data = 8'b00000000; // 0
        9'b011111011: // fb
            data = 8'b00000000; // 0
        9'b011111100: // fc
            data = 8'b00000000; // 0
        9'b011111101: // fd
            data = 8'b00000000; // 0
        9'b011111110: // fe
            data = 8'b00000000; // 0
        9'b011111111: // ff
            data = 8'b00000000; // 0
        9'b100000000: // 100
            data = 8'b00000000; // 0
        9'b100000001: // 101
            data = 8'b00000000; // 0
        9'b100000010: // 102
            data = 8'b00000000; // 0
        9'b100000011: // 103
            data = 8'b00000000; // 0
        9'b100000100: // 104
            data = 8'b00000000; // 0
        9'b100000101: // 105
            data = 8'b00000000; // 0
        9'b100000110: // 106
            data = 8'b00000000; // 0
        9'b100000111: // 107
            data = 8'b11110111; // f7
        9'b100001000: // 108
            data = 8'b11110110; // f6
        9'b100001001: // 109
            data = 8'b11110101; // f5
        9'b100001010: // 10a
            data = 8'b11110100; // f4
        9'b100001011: // 10b
            data = 8'b11110011; // f3
        9'b100001100: // 10c
            data = 8'b11110010; // f2
        9'b100001101: // 10d
            data = 8'b11110001; // f1
        9'b100001110: // 10e
            data = 8'b11110000; // f0
        9'b100001111: // 10f
            data = 8'b11101111; // ef
        9'b100010000: // 110
            data = 8'b11101110; // ee
        9'b100010001: // 111
            data = 8'b11101101; // ed
        9'b100010010: // 112
            data = 8'b11101100; // ec
        9'b100010011: // 113
            data = 8'b11101011; // eb
        9'b100010100: // 114
            data = 8'b11101010; // ea
        9'b100010101: // 115
            data = 8'b11101001; // e9
        9'b100010110: // 116
            data = 8'b11101000; // e8
        9'b100010111: // 117
            data = 8'b11100111; // e7
        9'b100011000: // 118
            data = 8'b11100110; // e6
        9'b100011001: // 119
            data = 8'b11100101; // e5
        9'b100011010: // 11a
            data = 8'b11100100; // e4
        9'b100011011: // 11b
            data = 8'b11100011; // e3
        9'b100011100: // 11c
            data = 8'b11100010; // e2
        9'b100011101: // 11d
            data = 8'b11100001; // e1
        9'b100011110: // 11e
            data = 8'b11100000; // e0
        9'b100011111: // 11f
            data = 8'b11011111; // df
        9'b100100000: // 120
            data = 8'b11011110; // de
        9'b100100001: // 121
            data = 8'b11011101; // dd
        9'b100100010: // 122
            data = 8'b11011100; // dc
        9'b100100011: // 123
            data = 8'b11011011; // db
        9'b100100100: // 124
            data = 8'b11011010; // da
        9'b100100101: // 125
            data = 8'b11011001; // d9
        9'b100100110: // 126
            data = 8'b11011000; // d8
        9'b100100111: // 127
            data = 8'b11010111; // d7
        9'b100101000: // 128
            data = 8'b11010110; // d6
        9'b100101001: // 129
            data = 8'b11010101; // d5
        9'b100101010: // 12a
            data = 8'b11010100; // d4
        9'b100101011: // 12b
            data = 8'b11010011; // d3
        9'b100101100: // 12c
            data = 8'b11010010; // d2
        9'b100101101: // 12d
            data = 8'b11010001; // d1
        9'b100101110: // 12e
            data = 8'b11010000; // d0
        9'b100101111: // 12f
            data = 8'b11001111; // cf
        9'b100110000: // 130
            data = 8'b11001110; // ce
        9'b100110001: // 131
            data = 8'b11001101; // cd
        9'b100110010: // 132
            data = 8'b11001100; // cc
        9'b100110011: // 133
            data = 8'b11001011; // cb
        9'b100110100: // 134
            data = 8'b11001010; // ca
        9'b100110101: // 135
            data = 8'b11001001; // c9
        9'b100110110: // 136
            data = 8'b11001000; // c8
        9'b100110111: // 137
            data = 8'b11000111; // c7
        9'b100111000: // 138
            data = 8'b11000110; // c6
        9'b100111001: // 139
            data = 8'b11000101; // c5
        9'b100111010: // 13a
            data = 8'b11000100; // c4
        9'b100111011: // 13b
            data = 8'b11000011; // c3
        9'b100111100: // 13c
            data = 8'b11000010; // c2
        9'b100111101: // 13d
            data = 8'b11000001; // c1
        9'b100111110: // 13e
            data = 8'b11000000; // c0
        9'b100111111: // 13f
            data = 8'b10111111; // bf
        9'b101000000: // 140
            data = 8'b10111110; // be
        9'b101000001: // 141
            data = 8'b10111101; // bd
        9'b101000010: // 142
            data = 8'b10111100; // bc
        9'b101000011: // 143
            data = 8'b10111011; // bb
        9'b101000100: // 144
            data = 8'b10111010; // ba
        9'b101000101: // 145
            data = 8'b10111001; // b9
        9'b101000110: // 146
            data = 8'b10111000; // b8
        9'b101000111: // 147
            data = 8'b10110111; // b7
        9'b101001000: // 148
            data = 8'b10110110; // b6
        9'b101001001: // 149
            data = 8'b10110101; // b5
        9'b101001010: // 14a
            data = 8'b10110100; // b4
        9'b101001011: // 14b
            data = 8'b10110011; // b3
        9'b101001100: // 14c
            data = 8'b10110010; // b2
        9'b101001101: // 14d
            data = 8'b10110001; // b1
        9'b101001110: // 14e
            data = 8'b10110000; // b0
        9'b101001111: // 14f
            data = 8'b10101111; // af
        9'b101010000: // 150
            data = 8'b10101110; // ae
        9'b101010001: // 151
            data = 8'b10101101; // ad
        9'b101010010: // 152
            data = 8'b10101100; // ac
        9'b101010011: // 153
            data = 8'b10101011; // ab
        9'b101010100: // 154
            data = 8'b10101010; // aa
        9'b101010101: // 155
            data = 8'b10101001; // a9
        9'b101010110: // 156
            data = 8'b10101000; // a8
        9'b101010111: // 157
            data = 8'b10100111; // a7
        9'b101011000: // 158
            data = 8'b10100110; // a6
        9'b101011001: // 159
            data = 8'b10100101; // a5
        9'b101011010: // 15a
            data = 8'b10100100; // a4
        9'b101011011: // 15b
            data = 8'b10100011; // a3
        9'b101011100: // 15c
            data = 8'b10100010; // a2
        9'b101011101: // 15d
            data = 8'b10100001; // a1
        9'b101011110: // 15e
            data = 8'b10100000; // a0
        9'b101011111: // 15f
            data = 8'b10011111; // 9f
        9'b101100000: // 160
            data = 8'b10011110; // 9e
        9'b101100001: // 161
            data = 8'b10011101; // 9d
        9'b101100010: // 162
            data = 8'b10011100; // 9c
        9'b101100011: // 163
            data = 8'b10011011; // 9b
        9'b101100100: // 164
            data = 8'b10011010; // 9a
        9'b101100101: // 165
            data = 8'b10011001; // 99
        9'b101100110: // 166
            data = 8'b10011000; // 98
        9'b101100111: // 167
            data = 8'b10010111; // 97
        9'b101101000: // 168
            data = 8'b10010110; // 96
        9'b101101001: // 169
            data = 8'b10010101; // 95
        9'b101101010: // 16a
            data = 8'b10010100; // 94
        9'b101101011: // 16b
            data = 8'b10010011; // 93
        9'b101101100: // 16c
            data = 8'b10010010; // 92
        9'b101101101: // 16d
            data = 8'b10010001; // 91
        9'b101101110: // 16e
            data = 8'b10010000; // 90
        9'b101101111: // 16f
            data = 8'b10001111; // 8f
        9'b101110000: // 170
            data = 8'b10001110; // 8e
        9'b101110001: // 171
            data = 8'b10001101; // 8d
        9'b101110010: // 172
            data = 8'b10001100; // 8c
        9'b101110011: // 173
            data = 8'b10001011; // 8b
        9'b101110100: // 174
            data = 8'b10001010; // 8a
        9'b101110101: // 175
            data = 8'b10001001; // 89
        9'b101110110: // 176
            data = 8'b10001000; // 88
        9'b101110111: // 177
            data = 8'b10000111; // 87
        9'b101111000: // 178
            data = 8'b10000110; // 86
        9'b101111001: // 179
            data = 8'b10000101; // 85
        9'b101111010: // 17a
            data = 8'b10000100; // 84
        9'b101111011: // 17b
            data = 8'b10000011; // 83
        9'b101111100: // 17c
            data = 8'b10000010; // 82
        9'b101111101: // 17d
            data = 8'b10000001; // 81
        9'b101111110: // 17e
            data = 8'b10000000; // 80
        9'b101111111: // 17f
            data = 8'b01111111; // 7f
        9'b110000000: // 180
            data = 8'b01111110; // 7e
        9'b110000001: // 181
            data = 8'b01111101; // 7d
        9'b110000010: // 182
            data = 8'b01111100; // 7c
        9'b110000011: // 183
            data = 8'b01111011; // 7b
        9'b110000100: // 184
            data = 8'b01111010; // 7a
        9'b110000101: // 185
            data = 8'b01111001; // 79
        9'b110000110: // 186
            data = 8'b01111000; // 78
        9'b110000111: // 187
            data = 8'b01110111; // 77
        9'b110001000: // 188
            data = 8'b01110110; // 76
        9'b110001001: // 189
            data = 8'b01110101; // 75
        9'b110001010: // 18a
            data = 8'b01110100; // 74
        9'b110001011: // 18b
            data = 8'b01110011; // 73
        9'b110001100: // 18c
            data = 8'b01110010; // 72
        9'b110001101: // 18d
            data = 8'b01110001; // 71
        9'b110001110: // 18e
            data = 8'b01110000; // 70
        9'b110001111: // 18f
            data = 8'b01101111; // 6f
        9'b110010000: // 190
            data = 8'b01101110; // 6e
        9'b110010001: // 191
            data = 8'b01101101; // 6d
        9'b110010010: // 192
            data = 8'b01101100; // 6c
        9'b110010011: // 193
            data = 8'b01101011; // 6b
        9'b110010100: // 194
            data = 8'b01101010; // 6a
        9'b110010101: // 195
            data = 8'b01101001; // 69
        9'b110010110: // 196
            data = 8'b01101000; // 68
        9'b110010111: // 197
            data = 8'b01100111; // 67
        9'b110011000: // 198
            data = 8'b01100110; // 66
        9'b110011001: // 199
            data = 8'b01100101; // 65
        9'b110011010: // 19a
            data = 8'b01100100; // 64
        9'b110011011: // 19b
            data = 8'b01100011; // 63
        9'b110011100: // 19c
            data = 8'b01100010; // 62
        9'b110011101: // 19d
            data = 8'b01100001; // 61
        9'b110011110: // 19e
            data = 8'b01100000; // 60
        9'b110011111: // 19f
            data = 8'b01011111; // 5f
        9'b110100000: // 1a0
            data = 8'b01011110; // 5e
        9'b110100001: // 1a1
            data = 8'b01011101; // 5d
        9'b110100010: // 1a2
            data = 8'b01011100; // 5c
        9'b110100011: // 1a3
            data = 8'b01011011; // 5b
        9'b110100100: // 1a4
            data = 8'b01011010; // 5a
        9'b110100101: // 1a5
            data = 8'b01011001; // 59
        9'b110100110: // 1a6
            data = 8'b01011000; // 58
        9'b110100111: // 1a7
            data = 8'b01010111; // 57
        9'b110101000: // 1a8
            data = 8'b01010110; // 56
        9'b110101001: // 1a9
            data = 8'b01010101; // 55
        9'b110101010: // 1aa
            data = 8'b01010100; // 54
        9'b110101011: // 1ab
            data = 8'b01010011; // 53
        9'b110101100: // 1ac
            data = 8'b01010010; // 52
        9'b110101101: // 1ad
            data = 8'b01010001; // 51
        9'b110101110: // 1ae
            data = 8'b01010000; // 50
        9'b110101111: // 1af
            data = 8'b01001111; // 4f
        9'b110110000: // 1b0
            data = 8'b01001110; // 4e
        9'b110110001: // 1b1
            data = 8'b01001101; // 4d
        9'b110110010: // 1b2
            data = 8'b01001100; // 4c
        9'b110110011: // 1b3
            data = 8'b01001011; // 4b
        9'b110110100: // 1b4
            data = 8'b01001010; // 4a
        9'b110110101: // 1b5
            data = 8'b01001001; // 49
        9'b110110110: // 1b6
            data = 8'b01001000; // 48
        9'b110110111: // 1b7
            data = 8'b01000111; // 47
        9'b110111000: // 1b8
            data = 8'b01000110; // 46
        9'b110111001: // 1b9
            data = 8'b01000101; // 45
        9'b110111010: // 1ba
            data = 8'b01000100; // 44
        9'b110111011: // 1bb
            data = 8'b01000011; // 43
        9'b110111100: // 1bc
            data = 8'b01000010; // 42
        9'b110111101: // 1bd
            data = 8'b01000001; // 41
        9'b110111110: // 1be
            data = 8'b01000000; // 40
        9'b110111111: // 1bf
            data = 8'b00111111; // 3f
        9'b111000000: // 1c0
            data = 8'b00111110; // 3e
        9'b111000001: // 1c1
            data = 8'b00111101; // 3d
        9'b111000010: // 1c2
            data = 8'b00111100; // 3c
        9'b111000011: // 1c3
            data = 8'b00111011; // 3b
        9'b111000100: // 1c4
            data = 8'b00111010; // 3a
        9'b111000101: // 1c5
            data = 8'b00111001; // 39
        9'b111000110: // 1c6
            data = 8'b00111000; // 38
        9'b111000111: // 1c7
            data = 8'b00110111; // 37
        9'b111001000: // 1c8
            data = 8'b00110110; // 36
        9'b111001001: // 1c9
            data = 8'b00110101; // 35
        9'b111001010: // 1ca
            data = 8'b00110100; // 34
        9'b111001011: // 1cb
            data = 8'b00110011; // 33
        9'b111001100: // 1cc
            data = 8'b00110010; // 32
        9'b111001101: // 1cd
            data = 8'b00110001; // 31
        9'b111001110: // 1ce
            data = 8'b00110000; // 30
        9'b111001111: // 1cf
            data = 8'b00101111; // 2f
        9'b111010000: // 1d0
            data = 8'b00101110; // 2e
        9'b111010001: // 1d1
            data = 8'b00101101; // 2d
        9'b111010010: // 1d2
            data = 8'b00101100; // 2c
        9'b111010011: // 1d3
            data = 8'b00101011; // 2b
        9'b111010100: // 1d4
            data = 8'b00101010; // 2a
        9'b111010101: // 1d5
            data = 8'b00101001; // 29
        9'b111010110: // 1d6
            data = 8'b00101000; // 28
        9'b111010111: // 1d7
            data = 8'b00100111; // 27
        9'b111011000: // 1d8
            data = 8'b00100110; // 26
        9'b111011001: // 1d9
            data = 8'b00100101; // 25
        9'b111011010: // 1da
            data = 8'b00100100; // 24
        9'b111011011: // 1db
            data = 8'b00100011; // 23
        9'b111011100: // 1dc
            data = 8'b00100010; // 22
        9'b111011101: // 1dd
            data = 8'b00100001; // 21
        9'b111011110: // 1de
            data = 8'b00100000; // 20
        9'b111011111: // 1df
            data = 8'b00011111; // 1f
        9'b111100000: // 1e0
            data = 8'b00011110; // 1e
        9'b111100001: // 1e1
            data = 8'b00011101; // 1d
        9'b111100010: // 1e2
            data = 8'b00011100; // 1c
        9'b111100011: // 1e3
            data = 8'b00011011; // 1b
        9'b111100100: // 1e4
            data = 8'b00011010; // 1a
        9'b111100101: // 1e5
            data = 8'b00011001; // 19
        9'b111100110: // 1e6
            data = 8'b00011000; // 18
        9'b111100111: // 1e7
            data = 8'b00010111; // 17
        9'b111101000: // 1e8
            data = 8'b00010110; // 16
        9'b111101001: // 1e9
            data = 8'b00010101; // 15
        9'b111101010: // 1ea
            data = 8'b00010100; // 14
        9'b111101011: // 1eb
            data = 8'b00010011; // 13
        9'b111101100: // 1ec
            data = 8'b00010010; // 12
        9'b111101101: // 1ed
            data = 8'b00010001; // 11
        9'b111101110: // 1ee
            data = 8'b00010000; // 10
        9'b111101111: // 1ef
            data = 8'b00001111; // f
        9'b111110000: // 1f0
            data = 8'b00001110; // e
        9'b111110001: // 1f1
            data = 8'b00001101; // d
        9'b111110010: // 1f2
            data = 8'b00001100; // c
        9'b111110011: // 1f3
            data = 8'b00001011; // b
        9'b111110100: // 1f4
            data = 8'b00001010; // a
        9'b111110101: // 1f5
            data = 8'b00001001; // 9
        9'b111110110: // 1f6
            data = 8'b00001000; // 8
        9'b111110111: // 1f7
            data = 8'b00000111; // 7
        9'b111111000: // 1f8
            data = 8'b00000110; // 6
        9'b111111001: // 1f9
            data = 8'b00000101; // 5
        9'b111111010: // 1fa
            data = 8'b00000100; // 4
        9'b111111011: // 1fb
            data = 8'b00000011; // 3
        9'b111111100: // 1fc
            data = 8'b00000010; // 2
        9'b111111101: // 1fd
            data = 8'b00000001; // 1
        9'b111111110: // 1fe
            data = 8'b00000000; // 0
        9'b111111111: // 1ff
            data = 8'b00000000; // 0

        default:
            data = 8'b0;
        endcase
endmodule

