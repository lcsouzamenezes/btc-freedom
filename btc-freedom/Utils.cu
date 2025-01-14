﻿#include "Utils.cuh"

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <openssl/bn.h>

static char nibble_to_char(uint8_t nibble) {
	return (nibble < 10) ? nibble + '0' : (nibble - 10) + 'a';
}

static uint8_t char_to_nibble(char character) {
	if (('a' <= character) && (character <= 'f')) return (character - 'a') + 10;
	return character - '0';
}

void Utils::bytes_to_hex(uint8_t* bytes, size_t bytes_len, char* hex, size_t hex_len) {
	if (((bytes_len << 1) + 1) > hex_len) return;

	int j = 0;
	for (int i = 0; i < bytes_len; i++) {
		uint8_t byte = bytes[i];
		char char1 = nibble_to_char(byte >> 4);
		char char2 = nibble_to_char(byte & 0x0F);

		hex[j++] = char1;
		hex[j++] = char2;

		//printf("byte = 0x%02X | char1 = '%c' | char2 = '%c' \n", byte, char1, char2);
	}

	hex[j++] = '\0';
}

void Utils::hex_to_bytes(char* hex, uint8_t* bytes, size_t bytes_len) {
	size_t hex_len = strlen(hex);
	if (bytes_len < (hex_len >> 1)) return;

	int j = 0;
	for (int i = 0; i < hex_len;) {
		uint8_t upper_nibble = (char_to_nibble(hex[i++]) << 4);
		uint8_t lower_nibble = char_to_nibble(hex[i++]);
		uint8_t byte = (upper_nibble | lower_nibble);
		
		//printf("un = 0x%02X | ln = 0x%02X | byte = 0x%02X \n", upper_nibble, lower_nibble, byte);
		bytes[j++] = byte;
	}
}
