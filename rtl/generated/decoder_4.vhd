-- From ../../roms/mame/robotron/decoder.4
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
 
entity __/__/roms/mame/robotron/decoder_4 is
    port(
        address     : in    std_logic_vector(8 downto 0);
        data        : out   std_logic_vector(7 downto 0)
    );
end __/__/roms/mame/robotron/decoder_4;

architecture Behavioral of __/__/roms/mame/robotron/decoder_4 is
begin

    process(address)
    begin
        case address is
        when "000000000" => -- 0
            data <= "10000001"; -- 81
        when "000000001" => -- 1
            data <= "00000010"; -- 2
        when "000000010" => -- 2
            data <= "01000010"; -- 42
        when "000000011" => -- 3
            data <= "10000010"; -- 82
        when "000000100" => -- 4
            data <= "00000011"; -- 3
        when "000000101" => -- 5
            data <= "01000011"; -- 43
        when "000000110" => -- 6
            data <= "10000011"; -- 83
        when "000000111" => -- 7
            data <= "00000100"; -- 4
        when "000001000" => -- 8
            data <= "01000100"; -- 44
        when "000001001" => -- 9
            data <= "10000100"; -- 84
        when "000001010" => -- a
            data <= "00000101"; -- 5
        when "000001011" => -- b
            data <= "01000101"; -- 45
        when "000001100" => -- c
            data <= "10000101"; -- 85
        when "000001101" => -- d
            data <= "00000110"; -- 6
        when "000001110" => -- e
            data <= "01000110"; -- 46
        when "000001111" => -- f
            data <= "10000110"; -- 86
        when "000010000" => -- 10
            data <= "00000111"; -- 7
        when "000010001" => -- 11
            data <= "01000111"; -- 47
        when "000010010" => -- 12
            data <= "10000111"; -- 87
        when "000010011" => -- 13
            data <= "00001000"; -- 8
        when "000010100" => -- 14
            data <= "01001000"; -- 48
        when "000010101" => -- 15
            data <= "10001000"; -- 88
        when "000010110" => -- 16
            data <= "00001001"; -- 9
        when "000010111" => -- 17
            data <= "01001001"; -- 49
        when "000011000" => -- 18
            data <= "10001001"; -- 89
        when "000011001" => -- 19
            data <= "00001010"; -- a
        when "000011010" => -- 1a
            data <= "01001010"; -- 4a
        when "000011011" => -- 1b
            data <= "10001010"; -- 8a
        when "000011100" => -- 1c
            data <= "00001011"; -- b
        when "000011101" => -- 1d
            data <= "01001011"; -- 4b
        when "000011110" => -- 1e
            data <= "10001011"; -- 8b
        when "000011111" => -- 1f
            data <= "00001100"; -- c
        when "000100000" => -- 20
            data <= "01001100"; -- 4c
        when "000100001" => -- 21
            data <= "10001100"; -- 8c
        when "000100010" => -- 22
            data <= "00001101"; -- d
        when "000100011" => -- 23
            data <= "01001101"; -- 4d
        when "000100100" => -- 24
            data <= "10001101"; -- 8d
        when "000100101" => -- 25
            data <= "00001110"; -- e
        when "000100110" => -- 26
            data <= "01001110"; -- 4e
        when "000100111" => -- 27
            data <= "10001110"; -- 8e
        when "000101000" => -- 28
            data <= "00001111"; -- f
        when "000101001" => -- 29
            data <= "01001111"; -- 4f
        when "000101010" => -- 2a
            data <= "10001111"; -- 8f
        when "000101011" => -- 2b
            data <= "00010000"; -- 10
        when "000101100" => -- 2c
            data <= "01010000"; -- 50
        when "000101101" => -- 2d
            data <= "10010000"; -- 90
        when "000101110" => -- 2e
            data <= "00010001"; -- 11
        when "000101111" => -- 2f
            data <= "01010001"; -- 51
        when "000110000" => -- 30
            data <= "10010001"; -- 91
        when "000110001" => -- 31
            data <= "00010010"; -- 12
        when "000110010" => -- 32
            data <= "01010010"; -- 52
        when "000110011" => -- 33
            data <= "10010010"; -- 92
        when "000110100" => -- 34
            data <= "00010011"; -- 13
        when "000110101" => -- 35
            data <= "01010011"; -- 53
        when "000110110" => -- 36
            data <= "10010011"; -- 93
        when "000110111" => -- 37
            data <= "00010100"; -- 14
        when "000111000" => -- 38
            data <= "01010100"; -- 54
        when "000111001" => -- 39
            data <= "10010100"; -- 94
        when "000111010" => -- 3a
            data <= "00010101"; -- 15
        when "000111011" => -- 3b
            data <= "01010101"; -- 55
        when "000111100" => -- 3c
            data <= "10010101"; -- 95
        when "000111101" => -- 3d
            data <= "00010110"; -- 16
        when "000111110" => -- 3e
            data <= "01010110"; -- 56
        when "000111111" => -- 3f
            data <= "10010110"; -- 96
        when "001000000" => -- 40
            data <= "00010111"; -- 17
        when "001000001" => -- 41
            data <= "01010111"; -- 57
        when "001000010" => -- 42
            data <= "10010111"; -- 97
        when "001000011" => -- 43
            data <= "00011000"; -- 18
        when "001000100" => -- 44
            data <= "01011000"; -- 58
        when "001000101" => -- 45
            data <= "10011000"; -- 98
        when "001000110" => -- 46
            data <= "00011001"; -- 19
        when "001000111" => -- 47
            data <= "01011001"; -- 59
        when "001001000" => -- 48
            data <= "10011001"; -- 99
        when "001001001" => -- 49
            data <= "00011010"; -- 1a
        when "001001010" => -- 4a
            data <= "01011010"; -- 5a
        when "001001011" => -- 4b
            data <= "10011010"; -- 9a
        when "001001100" => -- 4c
            data <= "00011011"; -- 1b
        when "001001101" => -- 4d
            data <= "01011011"; -- 5b
        when "001001110" => -- 4e
            data <= "10011011"; -- 9b
        when "001001111" => -- 4f
            data <= "00011100"; -- 1c
        when "001010000" => -- 50
            data <= "01011100"; -- 5c
        when "001010001" => -- 51
            data <= "10011100"; -- 9c
        when "001010010" => -- 52
            data <= "00011101"; -- 1d
        when "001010011" => -- 53
            data <= "01011101"; -- 5d
        when "001010100" => -- 54
            data <= "10011101"; -- 9d
        when "001010101" => -- 55
            data <= "00011110"; -- 1e
        when "001010110" => -- 56
            data <= "01011110"; -- 5e
        when "001010111" => -- 57
            data <= "10011110"; -- 9e
        when "001011000" => -- 58
            data <= "00011111"; -- 1f
        when "001011001" => -- 59
            data <= "01011111"; -- 5f
        when "001011010" => -- 5a
            data <= "10011111"; -- 9f
        when "001011011" => -- 5b
            data <= "00100000"; -- 20
        when "001011100" => -- 5c
            data <= "01100000"; -- 60
        when "001011101" => -- 5d
            data <= "10100000"; -- a0
        when "001011110" => -- 5e
            data <= "00100001"; -- 21
        when "001011111" => -- 5f
            data <= "01100001"; -- 61
        when "001100000" => -- 60
            data <= "10100001"; -- a1
        when "001100001" => -- 61
            data <= "00100010"; -- 22
        when "001100010" => -- 62
            data <= "01100010"; -- 62
        when "001100011" => -- 63
            data <= "10100010"; -- a2
        when "001100100" => -- 64
            data <= "00100011"; -- 23
        when "001100101" => -- 65
            data <= "01100011"; -- 63
        when "001100110" => -- 66
            data <= "10100011"; -- a3
        when "001100111" => -- 67
            data <= "00100100"; -- 24
        when "001101000" => -- 68
            data <= "01100100"; -- 64
        when "001101001" => -- 69
            data <= "10100100"; -- a4
        when "001101010" => -- 6a
            data <= "00100101"; -- 25
        when "001101011" => -- 6b
            data <= "01100101"; -- 65
        when "001101100" => -- 6c
            data <= "10100101"; -- a5
        when "001101101" => -- 6d
            data <= "00100110"; -- 26
        when "001101110" => -- 6e
            data <= "01100110"; -- 66
        when "001101111" => -- 6f
            data <= "10100110"; -- a6
        when "001110000" => -- 70
            data <= "00100111"; -- 27
        when "001110001" => -- 71
            data <= "01100111"; -- 67
        when "001110010" => -- 72
            data <= "10100111"; -- a7
        when "001110011" => -- 73
            data <= "00101000"; -- 28
        when "001110100" => -- 74
            data <= "01101000"; -- 68
        when "001110101" => -- 75
            data <= "10101000"; -- a8
        when "001110110" => -- 76
            data <= "00101001"; -- 29
        when "001110111" => -- 77
            data <= "01101001"; -- 69
        when "001111000" => -- 78
            data <= "10101001"; -- a9
        when "001111001" => -- 79
            data <= "00101010"; -- 2a
        when "001111010" => -- 7a
            data <= "01101010"; -- 6a
        when "001111011" => -- 7b
            data <= "10101010"; -- aa
        when "001111100" => -- 7c
            data <= "00101011"; -- 2b
        when "001111101" => -- 7d
            data <= "01101011"; -- 6b
        when "001111110" => -- 7e
            data <= "10101011"; -- ab
        when "001111111" => -- 7f
            data <= "00101100"; -- 2c
        when "010000000" => -- 80
            data <= "01101100"; -- 6c
        when "010000001" => -- 81
            data <= "10101100"; -- ac
        when "010000010" => -- 82
            data <= "00101101"; -- 2d
        when "010000011" => -- 83
            data <= "01101101"; -- 6d
        when "010000100" => -- 84
            data <= "10101101"; -- ad
        when "010000101" => -- 85
            data <= "00101110"; -- 2e
        when "010000110" => -- 86
            data <= "01101110"; -- 6e
        when "010000111" => -- 87
            data <= "10101110"; -- ae
        when "010001000" => -- 88
            data <= "00101111"; -- 2f
        when "010001001" => -- 89
            data <= "01101111"; -- 6f
        when "010001010" => -- 8a
            data <= "10101111"; -- af
        when "010001011" => -- 8b
            data <= "00110000"; -- 30
        when "010001100" => -- 8c
            data <= "01110000"; -- 70
        when "010001101" => -- 8d
            data <= "10110000"; -- b0
        when "010001110" => -- 8e
            data <= "00110001"; -- 31
        when "010001111" => -- 8f
            data <= "01110001"; -- 71
        when "010010000" => -- 90
            data <= "10110001"; -- b1
        when "010010001" => -- 91
            data <= "00110010"; -- 32
        when "010010010" => -- 92
            data <= "01110010"; -- 72
        when "010010011" => -- 93
            data <= "10110010"; -- b2
        when "010010100" => -- 94
            data <= "00110011"; -- 33
        when "010010101" => -- 95
            data <= "01110011"; -- 73
        when "010010110" => -- 96
            data <= "10110011"; -- b3
        when "010010111" => -- 97
            data <= "00110100"; -- 34
        when "010011000" => -- 98
            data <= "01110100"; -- 74
        when "010011001" => -- 99
            data <= "10110100"; -- b4
        when "010011010" => -- 9a
            data <= "00110101"; -- 35
        when "010011011" => -- 9b
            data <= "01110101"; -- 75
        when "010011100" => -- 9c
            data <= "10110101"; -- b5
        when "010011101" => -- 9d
            data <= "00110110"; -- 36
        when "010011110" => -- 9e
            data <= "01110110"; -- 76
        when "010011111" => -- 9f
            data <= "10110110"; -- b6
        when "010100000" => -- a0
            data <= "00110111"; -- 37
        when "010100001" => -- a1
            data <= "01110111"; -- 77
        when "010100010" => -- a2
            data <= "10110111"; -- b7
        when "010100011" => -- a3
            data <= "00111000"; -- 38
        when "010100100" => -- a4
            data <= "01111000"; -- 78
        when "010100101" => -- a5
            data <= "10111000"; -- b8
        when "010100110" => -- a6
            data <= "00111001"; -- 39
        when "010100111" => -- a7
            data <= "01111001"; -- 79
        when "010101000" => -- a8
            data <= "10111001"; -- b9
        when "010101001" => -- a9
            data <= "00111010"; -- 3a
        when "010101010" => -- aa
            data <= "01111010"; -- 7a
        when "010101011" => -- ab
            data <= "10111010"; -- ba
        when "010101100" => -- ac
            data <= "00111011"; -- 3b
        when "010101101" => -- ad
            data <= "01111011"; -- 7b
        when "010101110" => -- ae
            data <= "10111011"; -- bb
        when "010101111" => -- af
            data <= "00111100"; -- 3c
        when "010110000" => -- b0
            data <= "01111100"; -- 7c
        when "010110001" => -- b1
            data <= "10111100"; -- bc
        when "010110010" => -- b2
            data <= "00111101"; -- 3d
        when "010110011" => -- b3
            data <= "01111101"; -- 7d
        when "010110100" => -- b4
            data <= "10111101"; -- bd
        when "010110101" => -- b5
            data <= "00111110"; -- 3e
        when "010110110" => -- b6
            data <= "01111110"; -- 7e
        when "010110111" => -- b7
            data <= "10111110"; -- be
        when "010111000" => -- b8
            data <= "00111111"; -- 3f
        when "010111001" => -- b9
            data <= "01111111"; -- 7f
        when "010111010" => -- ba
            data <= "10111111"; -- bf
        when "010111011" => -- bb
            data <= "00000000"; -- 0
        when "010111100" => -- bc
            data <= "01000000"; -- 40
        when "010111101" => -- bd
            data <= "10000000"; -- 80
        when "010111110" => -- be
            data <= "00000001"; -- 1
        when "010111111" => -- bf
            data <= "01000001"; -- 41
        when "011000000" => -- c0
            data <= "11000011"; -- c3
        when "011000001" => -- c1
            data <= "11001111"; -- cf
        when "011000010" => -- c2
            data <= "11010000"; -- d0
        when "011000011" => -- c3
            data <= "11011001"; -- d9
        when "011000100" => -- c4
            data <= "11010010"; -- d2
        when "011000101" => -- c5
            data <= "11001001"; -- c9
        when "011000110" => -- c6
            data <= "11000111"; -- c7
        when "011000111" => -- c7
            data <= "11001000"; -- c8
        when "011001000" => -- c8
            data <= "11010100"; -- d4
        when "011001001" => -- c9
            data <= "10000000"; -- 80
        when "011001010" => -- ca
            data <= "10101000"; -- a8
        when "011001011" => -- cb
            data <= "11000011"; -- c3
        when "011001100" => -- cc
            data <= "10101001"; -- a9
        when "011001101" => -- cd
            data <= "10000000"; -- 80
        when "011001110" => -- ce
            data <= "10110001"; -- b1
        when "011001111" => -- cf
            data <= "10111001"; -- b9
        when "011010000" => -- d0
            data <= "10111000"; -- b8
        when "011010001" => -- d1
            data <= "10110001"; -- b1
        when "011010010" => -- d2
            data <= "10000000"; -- 80
        when "011010011" => -- d3
            data <= "11010111"; -- d7
        when "011010100" => -- d4
            data <= "11001001"; -- c9
        when "011010101" => -- d5
            data <= "11001100"; -- cc
        when "011010110" => -- d6
            data <= "11001100"; -- cc
        when "011010111" => -- d7
            data <= "11001001"; -- c9
        when "011011000" => -- d8
            data <= "11000001"; -- c1
        when "011011001" => -- d9
            data <= "11001101"; -- cd
        when "011011010" => -- da
            data <= "11010011"; -- d3
        when "011011011" => -- db
            data <= "10000000"; -- 80
        when "011011100" => -- dc
            data <= "11000101"; -- c5
        when "011011101" => -- dd
            data <= "11001100"; -- cc
        when "011011110" => -- de
            data <= "11000101"; -- c5
        when "011011111" => -- df
            data <= "11000011"; -- c3
        when "011100000" => -- e0
            data <= "11010100"; -- d4
        when "011100001" => -- e1
            data <= "11010010"; -- d2
        when "011100010" => -- e2
            data <= "11001111"; -- cf
        when "011100011" => -- e3
            data <= "11001110"; -- ce
        when "011100100" => -- e4
            data <= "11001001"; -- c9
        when "011100101" => -- e5
            data <= "11000011"; -- c3
        when "011100110" => -- e6
            data <= "11010011"; -- d3
        when "011100111" => -- e7
            data <= "10000000"; -- 80
        when "011101000" => -- e8
            data <= "11001001"; -- c9
        when "011101001" => -- e9
            data <= "11001110"; -- ce
        when "011101010" => -- ea
            data <= "11000011"; -- c3
        when "011101011" => -- eb
            data <= "10101110"; -- ae
        when "011101100" => -- ec
            data <= "10000000"; -- 80
        when "011101101" => -- ed
            data <= "11000001"; -- c1
        when "011101110" => -- ee
            data <= "11001100"; -- cc
        when "011101111" => -- ef
            data <= "11001100"; -- cc
        when "011110000" => -- f0
            data <= "10000000"; -- 80
        when "011110001" => -- f1
            data <= "11010010"; -- d2
        when "011110010" => -- f2
            data <= "11001001"; -- c9
        when "011110011" => -- f3
            data <= "11000111"; -- c7
        when "011110100" => -- f4
            data <= "11001000"; -- c8
        when "011110101" => -- f5
            data <= "11010100"; -- d4
        when "011110110" => -- f6
            data <= "11010011"; -- d3
        when "011110111" => -- f7
            data <= "10000000"; -- 80
        when "011111000" => -- f8
            data <= "11010010"; -- d2
        when "011111001" => -- f9
            data <= "11000101"; -- c5
        when "011111010" => -- fa
            data <= "11010011"; -- d3
        when "011111011" => -- fb
            data <= "11000101"; -- c5
        when "011111100" => -- fc
            data <= "11010010"; -- d2
        when "011111101" => -- fd
            data <= "11010110"; -- d6
        when "011111110" => -- fe
            data <= "11000101"; -- c5
        when "011111111" => -- ff
            data <= "11000100"; -- c4
        when "100000000" => -- 100
            data <= "00110100"; -- 34
        when "100000001" => -- 101
            data <= "10110011"; -- b3
        when "100000010" => -- 102
            data <= "01110011"; -- 73
        when "100000011" => -- 103
            data <= "00110011"; -- 33
        when "100000100" => -- 104
            data <= "10110010"; -- b2
        when "100000101" => -- 105
            data <= "01110010"; -- 72
        when "100000110" => -- 106
            data <= "00110010"; -- 32
        when "100000111" => -- 107
            data <= "10110001"; -- b1
        when "100001000" => -- 108
            data <= "01110001"; -- 71
        when "100001001" => -- 109
            data <= "00110001"; -- 31
        when "100001010" => -- 10a
            data <= "10110000"; -- b0
        when "100001011" => -- 10b
            data <= "01110000"; -- 70
        when "100001100" => -- 10c
            data <= "00110000"; -- 30
        when "100001101" => -- 10d
            data <= "10101111"; -- af
        when "100001110" => -- 10e
            data <= "01101111"; -- 6f
        when "100001111" => -- 10f
            data <= "00101111"; -- 2f
        when "100010000" => -- 110
            data <= "10101110"; -- ae
        when "100010001" => -- 111
            data <= "01101110"; -- 6e
        when "100010010" => -- 112
            data <= "00101110"; -- 2e
        when "100010011" => -- 113
            data <= "10101101"; -- ad
        when "100010100" => -- 114
            data <= "01101101"; -- 6d
        when "100010101" => -- 115
            data <= "00101101"; -- 2d
        when "100010110" => -- 116
            data <= "10101100"; -- ac
        when "100010111" => -- 117
            data <= "01101100"; -- 6c
        when "100011000" => -- 118
            data <= "00101100"; -- 2c
        when "100011001" => -- 119
            data <= "10101011"; -- ab
        when "100011010" => -- 11a
            data <= "01101011"; -- 6b
        when "100011011" => -- 11b
            data <= "00101011"; -- 2b
        when "100011100" => -- 11c
            data <= "10101010"; -- aa
        when "100011101" => -- 11d
            data <= "01101010"; -- 6a
        when "100011110" => -- 11e
            data <= "00101010"; -- 2a
        when "100011111" => -- 11f
            data <= "10101001"; -- a9
        when "100100000" => -- 120
            data <= "01101001"; -- 69
        when "100100001" => -- 121
            data <= "00101001"; -- 29
        when "100100010" => -- 122
            data <= "10101000"; -- a8
        when "100100011" => -- 123
            data <= "01101000"; -- 68
        when "100100100" => -- 124
            data <= "00101000"; -- 28
        when "100100101" => -- 125
            data <= "10100111"; -- a7
        when "100100110" => -- 126
            data <= "01100111"; -- 67
        when "100100111" => -- 127
            data <= "00100111"; -- 27
        when "100101000" => -- 128
            data <= "10100110"; -- a6
        when "100101001" => -- 129
            data <= "01100110"; -- 66
        when "100101010" => -- 12a
            data <= "00100110"; -- 26
        when "100101011" => -- 12b
            data <= "10100101"; -- a5
        when "100101100" => -- 12c
            data <= "01100101"; -- 65
        when "100101101" => -- 12d
            data <= "00100101"; -- 25
        when "100101110" => -- 12e
            data <= "10100100"; -- a4
        when "100101111" => -- 12f
            data <= "01100100"; -- 64
        when "100110000" => -- 130
            data <= "00100100"; -- 24
        when "100110001" => -- 131
            data <= "10100011"; -- a3
        when "100110010" => -- 132
            data <= "01100011"; -- 63
        when "100110011" => -- 133
            data <= "00100011"; -- 23
        when "100110100" => -- 134
            data <= "10100010"; -- a2
        when "100110101" => -- 135
            data <= "01100010"; -- 62
        when "100110110" => -- 136
            data <= "00100010"; -- 22
        when "100110111" => -- 137
            data <= "10100001"; -- a1
        when "100111000" => -- 138
            data <= "01100001"; -- 61
        when "100111001" => -- 139
            data <= "00100001"; -- 21
        when "100111010" => -- 13a
            data <= "10100000"; -- a0
        when "100111011" => -- 13b
            data <= "01100000"; -- 60
        when "100111100" => -- 13c
            data <= "00100000"; -- 20
        when "100111101" => -- 13d
            data <= "10011111"; -- 9f
        when "100111110" => -- 13e
            data <= "01011111"; -- 5f
        when "100111111" => -- 13f
            data <= "00011111"; -- 1f
        when "101000000" => -- 140
            data <= "10011110"; -- 9e
        when "101000001" => -- 141
            data <= "01011110"; -- 5e
        when "101000010" => -- 142
            data <= "00011110"; -- 1e
        when "101000011" => -- 143
            data <= "10011101"; -- 9d
        when "101000100" => -- 144
            data <= "01011101"; -- 5d
        when "101000101" => -- 145
            data <= "00011101"; -- 1d
        when "101000110" => -- 146
            data <= "10011100"; -- 9c
        when "101000111" => -- 147
            data <= "01011100"; -- 5c
        when "101001000" => -- 148
            data <= "00011100"; -- 1c
        when "101001001" => -- 149
            data <= "10011011"; -- 9b
        when "101001010" => -- 14a
            data <= "01011011"; -- 5b
        when "101001011" => -- 14b
            data <= "00011011"; -- 1b
        when "101001100" => -- 14c
            data <= "10011010"; -- 9a
        when "101001101" => -- 14d
            data <= "01011010"; -- 5a
        when "101001110" => -- 14e
            data <= "00011010"; -- 1a
        when "101001111" => -- 14f
            data <= "10011001"; -- 99
        when "101010000" => -- 150
            data <= "01011001"; -- 59
        when "101010001" => -- 151
            data <= "00011001"; -- 19
        when "101010010" => -- 152
            data <= "10011000"; -- 98
        when "101010011" => -- 153
            data <= "01011000"; -- 58
        when "101010100" => -- 154
            data <= "00011000"; -- 18
        when "101010101" => -- 155
            data <= "10010111"; -- 97
        when "101010110" => -- 156
            data <= "01010111"; -- 57
        when "101010111" => -- 157
            data <= "00010111"; -- 17
        when "101011000" => -- 158
            data <= "10010110"; -- 96
        when "101011001" => -- 159
            data <= "01010110"; -- 56
        when "101011010" => -- 15a
            data <= "00010110"; -- 16
        when "101011011" => -- 15b
            data <= "10010101"; -- 95
        when "101011100" => -- 15c
            data <= "01010101"; -- 55
        when "101011101" => -- 15d
            data <= "00010101"; -- 15
        when "101011110" => -- 15e
            data <= "10010100"; -- 94
        when "101011111" => -- 15f
            data <= "01010100"; -- 54
        when "101100000" => -- 160
            data <= "00010100"; -- 14
        when "101100001" => -- 161
            data <= "10010011"; -- 93
        when "101100010" => -- 162
            data <= "01010011"; -- 53
        when "101100011" => -- 163
            data <= "00010011"; -- 13
        when "101100100" => -- 164
            data <= "10010010"; -- 92
        when "101100101" => -- 165
            data <= "01010010"; -- 52
        when "101100110" => -- 166
            data <= "00010010"; -- 12
        when "101100111" => -- 167
            data <= "10010001"; -- 91
        when "101101000" => -- 168
            data <= "01010001"; -- 51
        when "101101001" => -- 169
            data <= "00010001"; -- 11
        when "101101010" => -- 16a
            data <= "10010000"; -- 90
        when "101101011" => -- 16b
            data <= "01010000"; -- 50
        when "101101100" => -- 16c
            data <= "00010000"; -- 10
        when "101101101" => -- 16d
            data <= "10001111"; -- 8f
        when "101101110" => -- 16e
            data <= "01001111"; -- 4f
        when "101101111" => -- 16f
            data <= "00001111"; -- f
        when "101110000" => -- 170
            data <= "10001110"; -- 8e
        when "101110001" => -- 171
            data <= "01001110"; -- 4e
        when "101110010" => -- 172
            data <= "00001110"; -- e
        when "101110011" => -- 173
            data <= "10001101"; -- 8d
        when "101110100" => -- 174
            data <= "01001101"; -- 4d
        when "101110101" => -- 175
            data <= "00001101"; -- d
        when "101110110" => -- 176
            data <= "10001100"; -- 8c
        when "101110111" => -- 177
            data <= "01001100"; -- 4c
        when "101111000" => -- 178
            data <= "00001100"; -- c
        when "101111001" => -- 179
            data <= "10001011"; -- 8b
        when "101111010" => -- 17a
            data <= "01001011"; -- 4b
        when "101111011" => -- 17b
            data <= "00001011"; -- b
        when "101111100" => -- 17c
            data <= "10001010"; -- 8a
        when "101111101" => -- 17d
            data <= "01001010"; -- 4a
        when "101111110" => -- 17e
            data <= "00001010"; -- a
        when "101111111" => -- 17f
            data <= "10001001"; -- 89
        when "110000000" => -- 180
            data <= "01001001"; -- 49
        when "110000001" => -- 181
            data <= "00001001"; -- 9
        when "110000010" => -- 182
            data <= "10001000"; -- 88
        when "110000011" => -- 183
            data <= "01001000"; -- 48
        when "110000100" => -- 184
            data <= "00001000"; -- 8
        when "110000101" => -- 185
            data <= "10000111"; -- 87
        when "110000110" => -- 186
            data <= "01000111"; -- 47
        when "110000111" => -- 187
            data <= "00000111"; -- 7
        when "110001000" => -- 188
            data <= "10000110"; -- 86
        when "110001001" => -- 189
            data <= "01000110"; -- 46
        when "110001010" => -- 18a
            data <= "00000110"; -- 6
        when "110001011" => -- 18b
            data <= "10000101"; -- 85
        when "110001100" => -- 18c
            data <= "01000101"; -- 45
        when "110001101" => -- 18d
            data <= "00000101"; -- 5
        when "110001110" => -- 18e
            data <= "10000100"; -- 84
        when "110001111" => -- 18f
            data <= "01000100"; -- 44
        when "110010000" => -- 190
            data <= "00000100"; -- 4
        when "110010001" => -- 191
            data <= "10000011"; -- 83
        when "110010010" => -- 192
            data <= "01000011"; -- 43
        when "110010011" => -- 193
            data <= "00000011"; -- 3
        when "110010100" => -- 194
            data <= "10000010"; -- 82
        when "110010101" => -- 195
            data <= "01000010"; -- 42
        when "110010110" => -- 196
            data <= "00000010"; -- 2
        when "110010111" => -- 197
            data <= "10000001"; -- 81
        when "110011000" => -- 198
            data <= "01110100"; -- 74
        when "110011001" => -- 199
            data <= "10110100"; -- b4
        when "110011010" => -- 19a
            data <= "00110101"; -- 35
        when "110011011" => -- 19b
            data <= "01110101"; -- 75
        when "110011100" => -- 19c
            data <= "10110101"; -- b5
        when "110011101" => -- 19d
            data <= "00110110"; -- 36
        when "110011110" => -- 19e
            data <= "01110110"; -- 76
        when "110011111" => -- 19f
            data <= "10110110"; -- b6
        when "110100000" => -- 1a0
            data <= "00110111"; -- 37
        when "110100001" => -- 1a1
            data <= "01110111"; -- 77
        when "110100010" => -- 1a2
            data <= "10110111"; -- b7
        when "110100011" => -- 1a3
            data <= "00111000"; -- 38
        when "110100100" => -- 1a4
            data <= "01111000"; -- 78
        when "110100101" => -- 1a5
            data <= "10111000"; -- b8
        when "110100110" => -- 1a6
            data <= "00111001"; -- 39
        when "110100111" => -- 1a7
            data <= "01111001"; -- 79
        when "110101000" => -- 1a8
            data <= "10111001"; -- b9
        when "110101001" => -- 1a9
            data <= "00111010"; -- 3a
        when "110101010" => -- 1aa
            data <= "01111010"; -- 7a
        when "110101011" => -- 1ab
            data <= "10111010"; -- ba
        when "110101100" => -- 1ac
            data <= "00111011"; -- 3b
        when "110101101" => -- 1ad
            data <= "01111011"; -- 7b
        when "110101110" => -- 1ae
            data <= "10111011"; -- bb
        when "110101111" => -- 1af
            data <= "00111100"; -- 3c
        when "110110000" => -- 1b0
            data <= "01111100"; -- 7c
        when "110110001" => -- 1b1
            data <= "10111100"; -- bc
        when "110110010" => -- 1b2
            data <= "00111101"; -- 3d
        when "110110011" => -- 1b3
            data <= "01111101"; -- 7d
        when "110110100" => -- 1b4
            data <= "10111101"; -- bd
        when "110110101" => -- 1b5
            data <= "00111110"; -- 3e
        when "110110110" => -- 1b6
            data <= "01111110"; -- 7e
        when "110110111" => -- 1b7
            data <= "10111110"; -- be
        when "110111000" => -- 1b8
            data <= "00111111"; -- 3f
        when "110111001" => -- 1b9
            data <= "01111111"; -- 7f
        when "110111010" => -- 1ba
            data <= "10111111"; -- bf
        when "110111011" => -- 1bb
            data <= "00000000"; -- 0
        when "110111100" => -- 1bc
            data <= "01000000"; -- 40
        when "110111101" => -- 1bd
            data <= "10000000"; -- 80
        when "110111110" => -- 1be
            data <= "00000001"; -- 1
        when "110111111" => -- 1bf
            data <= "01000001"; -- 41
        when "111000000" => -- 1c0
            data <= "11000011"; -- c3
        when "111000001" => -- 1c1
            data <= "11001111"; -- cf
        when "111000010" => -- 1c2
            data <= "11010000"; -- d0
        when "111000011" => -- 1c3
            data <= "11011001"; -- d9
        when "111000100" => -- 1c4
            data <= "11010010"; -- d2
        when "111000101" => -- 1c5
            data <= "11001001"; -- c9
        when "111000110" => -- 1c6
            data <= "11000111"; -- c7
        when "111000111" => -- 1c7
            data <= "11001000"; -- c8
        when "111001000" => -- 1c8
            data <= "11010100"; -- d4
        when "111001001" => -- 1c9
            data <= "10000000"; -- 80
        when "111001010" => -- 1ca
            data <= "10101000"; -- a8
        when "111001011" => -- 1cb
            data <= "11000011"; -- c3
        when "111001100" => -- 1cc
            data <= "10101001"; -- a9
        when "111001101" => -- 1cd
            data <= "10000000"; -- 80
        when "111001110" => -- 1ce
            data <= "10110001"; -- b1
        when "111001111" => -- 1cf
            data <= "10111001"; -- b9
        when "111010000" => -- 1d0
            data <= "10111000"; -- b8
        when "111010001" => -- 1d1
            data <= "10110001"; -- b1
        when "111010010" => -- 1d2
            data <= "10000000"; -- 80
        when "111010011" => -- 1d3
            data <= "11010111"; -- d7
        when "111010100" => -- 1d4
            data <= "11001001"; -- c9
        when "111010101" => -- 1d5
            data <= "11001100"; -- cc
        when "111010110" => -- 1d6
            data <= "11001100"; -- cc
        when "111010111" => -- 1d7
            data <= "11001001"; -- c9
        when "111011000" => -- 1d8
            data <= "11000001"; -- c1
        when "111011001" => -- 1d9
            data <= "11001101"; -- cd
        when "111011010" => -- 1da
            data <= "11010011"; -- d3
        when "111011011" => -- 1db
            data <= "10000000"; -- 80
        when "111011100" => -- 1dc
            data <= "11000101"; -- c5
        when "111011101" => -- 1dd
            data <= "11001100"; -- cc
        when "111011110" => -- 1de
            data <= "11000101"; -- c5
        when "111011111" => -- 1df
            data <= "11000011"; -- c3
        when "111100000" => -- 1e0
            data <= "11010100"; -- d4
        when "111100001" => -- 1e1
            data <= "11010010"; -- d2
        when "111100010" => -- 1e2
            data <= "11001111"; -- cf
        when "111100011" => -- 1e3
            data <= "11001110"; -- ce
        when "111100100" => -- 1e4
            data <= "11001001"; -- c9
        when "111100101" => -- 1e5
            data <= "11000011"; -- c3
        when "111100110" => -- 1e6
            data <= "11010011"; -- d3
        when "111100111" => -- 1e7
            data <= "10000000"; -- 80
        when "111101000" => -- 1e8
            data <= "11001001"; -- c9
        when "111101001" => -- 1e9
            data <= "11001110"; -- ce
        when "111101010" => -- 1ea
            data <= "11000011"; -- c3
        when "111101011" => -- 1eb
            data <= "10101110"; -- ae
        when "111101100" => -- 1ec
            data <= "10000000"; -- 80
        when "111101101" => -- 1ed
            data <= "11000001"; -- c1
        when "111101110" => -- 1ee
            data <= "11001100"; -- cc
        when "111101111" => -- 1ef
            data <= "11001100"; -- cc
        when "111110000" => -- 1f0
            data <= "10000000"; -- 80
        when "111110001" => -- 1f1
            data <= "11010010"; -- d2
        when "111110010" => -- 1f2
            data <= "11001001"; -- c9
        when "111110011" => -- 1f3
            data <= "11000111"; -- c7
        when "111110100" => -- 1f4
            data <= "11001000"; -- c8
        when "111110101" => -- 1f5
            data <= "11010100"; -- d4
        when "111110110" => -- 1f6
            data <= "11010011"; -- d3
        when "111110111" => -- 1f7
            data <= "10000000"; -- 80
        when "111111000" => -- 1f8
            data <= "11010010"; -- d2
        when "111111001" => -- 1f9
            data <= "11000101"; -- c5
        when "111111010" => -- 1fa
            data <= "11010011"; -- d3
        when "111111011" => -- 1fb
            data <= "11000101"; -- c5
        when "111111100" => -- 1fc
            data <= "11010010"; -- d2
        when "111111101" => -- 1fd
            data <= "11010110"; -- d6
        when "111111110" => -- 1fe
            data <= "11000101"; -- c5
        when "111111111" => -- 1ff
            data <= "11000100"; -- c4

        when others =>
            data <= (others => '0');
        end case;
    end process;
    
end Behavioral;

