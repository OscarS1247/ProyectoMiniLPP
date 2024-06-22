
	sub esp, 12
prg:
	push ebp
	mov ebp, esp
	sub esp, 0



	mov dword [ebp + 4], 65

	mov dword [ebp + 8], 27

	mov edx, dword [ebp + 4]
	add edx, dword [ebp + 8]
	mov dword [ebp - 52], edx


	mov eax, dword [ebp - 52]

	mov dword [ebp + 12], eax