#!/bin/sh

hidutil property --set '{"UserKeyMapping":[
	{"HIDKeyboardModifierMappingSrc":0x70000008b,"HIDKeyboardModifierMappingDst":0x700000091},
	{"HIDKeyboardModifierMappingSrc":0x70000008a,"HIDKeyboardModifierMappingDst":0x700000090},
]}'
