	.file	"C_GUI_Host_main.c"
	.text
	.globl	global_service
	.bss
	.align 8
	.type	global_service, @object
	.size	global_service, 8
global_service:
	.zero	8
	.globl	broadcast_info
	.align 8
	.type	broadcast_info, @object
	.size	broadcast_info, 8
broadcast_info:
	.zero	8
	.text
	.type	is_private_ip, @function
is_private_ip:
.LFB2446:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	andl	$-16777216, %eax
	cmpl	$167772160, %eax
	jne	.L2
	movl	$1, %eax
	jmp	.L3
.L2:
	movl	-4(%rbp), %eax
	andl	$-1048576, %eax
	cmpl	$-1408237568, %eax
	jne	.L4
	movl	$1, %eax
	jmp	.L3
.L4:
	movl	-4(%rbp), %eax
	movw	$0, %ax
	cmpl	$-1062731776, %eax
	jne	.L5
	movl	$1, %eax
	jmp	.L3
.L5:
	movl	$0, %eax
.L3:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2446:
	.size	is_private_ip, .-is_private_ip
	.section	.rodata
.LC0:
	.string	"getifaddrs"
	.align 8
.LC1:
	.string	"Detected hotspot IP: %s on interface %s\n"
	.align 8
.LC2:
	.string	"No private hotspot IP detected, using 255.255.255.255\n"
	.text
	.type	detect_hotspot_ip, @function
detect_hotspot_ip:
.LFB2447:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	getifaddrs@PLT
	cmpl	$-1, %eax
	jne	.L7
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L7:
	movl	$0, -64(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -48(%rbp)
	jmp	.L8
.L14:
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	testq	%rax, %rax
	je	.L18
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	movzwl	(%rax), %eax
	cmpw	$2, %ax
	jne	.L19
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movl	4(%rax), %eax
	movl	%eax, %edi
	call	ntohl@PLT
	movl	%eax, -60(%rbp)
	movl	-60(%rbp), %eax
	andl	$-16777216, %eax
	cmpl	$2130706432, %eax
	je	.L20
	movl	-60(%rbp), %eax
	movl	%eax, %edi
	call	is_private_ip
	testl	%eax, %eax
	je	.L10
	movl	-60(%rbp), %eax
	movl	%eax, -64(%rbp)
	movq	-40(%rbp), %rax
	leaq	4(%rax), %rsi
	leaq	-32(%rbp), %rax
	movl	$16, %ecx
	movq	%rax, %rdx
	movl	$2, %edi
	call	inet_ntop@PLT
	movq	-48(%rbp), %rax
	movq	8(%rax), %rdx
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L13
.L18:
	nop
	jmp	.L10
.L19:
	nop
	jmp	.L10
.L20:
	nop
.L10:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
.L8:
	cmpq	$0, -48(%rbp)
	jne	.L14
.L13:
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	freeifaddrs@PLT
	cmpl	$0, -64(%rbp)
	jne	.L15
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$54, %edx
	movl	$1, %esi
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$-1, -64(%rbp)
.L15:
	movl	-64(%rbp), %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L17
	call	__stack_chk_fail@PLT
.L17:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2447:
	.size	detect_hotspot_ip, .-detect_hotspot_ip
	.type	compute_broadcast, @function
compute_broadcast:
.LFB2448:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movl	$-256, -4(%rbp)
	movl	-20(%rbp), %eax
	xorb	$-1, %al
	andl	-4(%rbp), %eax
	xorb	$-1, %al
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2448:
	.size	compute_broadcast, .-compute_broadcast
	.section	.rodata
.LC3:
	.string	"SERVER_ALIVE"
.LC4:
	.string	"Broadcast send failed: %m"
	.text
	.globl	broadcast_callback
	.type	broadcast_callback, @function
broadcast_callback:
.LFB2449:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -40(%rbp)
	leaq	.LC3(%rip), %rax
	movq	%rax, -32(%rbp)
	movq	-40(%rbp), %rax
	leaq	4(%rax), %rbx
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	movq	-32(%rbp), %rsi
	movl	$16, %r9d
	movq	%rbx, %r8
	movl	$0, %ecx
	movl	%eax, %edi
	call	sendto@PLT
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jns	.L24
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdx
	movl	$16, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	g_log@PLT
.L24:
	movl	$1, %eax
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2449:
	.size	broadcast_callback, .-broadcast_callback
	.section	.rodata
	.align 8
.LC5:
	.string	"Shutting down Client Monitor...\n"
	.text
	.type	on_close_clicked, @function
on_close_clicked:
.LFB2450:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	g_print@PLT
	movq	global_service(%rip), %rax
	testq	%rax, %rax
	je	.L27
	movq	global_service(%rip), %rax
	movq	%rax, %rdi
	call	g_socket_service_stop@PLT
	movq	global_service(%rip), %rax
	movq	%rax, %rdi
	call	g_object_unref@PLT
	movq	$0, global_service(%rip)
.L27:
	movq	broadcast_info(%rip), %rax
	testq	%rax, %rax
	je	.L28
	movq	broadcast_info(%rip), %rax
	movl	(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	broadcast_info(%rip), %rax
	movq	%rax, %rdi
	call	g_free@PLT
	movq	$0, broadcast_info(%rip)
.L28:
	movq	waiting_tabs(%rip), %rax
	testq	%rax, %rax
	je	.L29
	movq	waiting_tabs(%rip), %rax
	movq	%rax, %rdi
	call	g_queue_free@PLT
	movq	$0, waiting_tabs(%rip)
.L29:
	leaq	queue_lock(%rip), %rax
	movq	%rax, %rdi
	call	g_mutex_clear@PLT
	call	gtk_main_quit@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2450:
	.size	on_close_clicked, .-on_close_clicked
	.section	.rodata
.LC6:
	.string	"Client Monitor"
.LC7:
	.string	"Main"
	.align 8
.LC8:
	.string	"Author: Thomas Schreck - written for:\nMeasurement and Sensor Technology Group\nTU Darmstadt"
.LC10:
	.string	"Start all Clients"
.LC11:
	.string	"clicked"
.LC12:
	.string	"Stop all Clients"
.LC13:
	.string	"Global Duration (seconds)"
.LC14:
	.string	"300"
.LC15:
	.string	"global_dur_entry"
.LC16:
	.string	"changed"
.LC17:
	.string	"Close Client Monitor"
.LC18:
	.string	"destroy"
.LC19:
	.string	"Failed to bind to port 8080\n"
.LC20:
	.string	"incoming"
.LC21:
	.string	"Broadcast socket() failed: %m"
	.text
	.globl	main
	.type	main, @function
main:
.LFB2451:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$152, %rsp
	.cfi_offset 3, -24
	movl	%edi, -148(%rbp)
	movq	%rsi, -160(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	leaq	-160(%rbp), %rdx
	leaq	-148(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	gtk_init@PLT
	call	g_queue_new@PLT
	movq	%rax, waiting_tabs(%rip)
	leaq	queue_lock(%rip), %rax
	movq	%rax, %rdi
	call	g_mutex_init@PLT
	movl	$0, %edi
	call	gtk_window_new@PLT
	movq	%rax, -128(%rbp)
	call	gtk_window_get_type@PLT
	movq	%rax, %rdx
	movq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC6(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gtk_window_set_title@PLT
	call	gtk_window_get_type@PLT
	movq	%rax, %rdx
	movq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movl	$600, %edx
	movl	$900, %esi
	movq	%rax, %rdi
	call	gtk_window_set_default_size@PLT
	call	gtk_notebook_new@PLT
	movq	%rax, -120(%rbp)
	call	gtk_container_get_type@PLT
	movq	%rax, %rdx
	movq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gtk_container_add@PLT
	call	gtk_overlay_new@PLT
	movq	%rax, -112(%rbp)
	movl	$10, %esi
	movl	$1, %edi
	call	gtk_box_new@PLT
	movq	%rax, -104(%rbp)
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	gtk_label_new@PLT
	movq	%rax, -96(%rbp)
	call	gtk_overlay_get_type@PLT
	movq	%rax, %rdx
	movq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	movq	-104(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gtk_overlay_add_overlay@PLT
	movq	-104(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_halign@PLT
	movq	-104(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_valign@PLT
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	gtk_label_new@PLT
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_halign@PLT
	movq	-88(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_valign@PLT
	movq	-88(%rbp), %rax
	movl	$10, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_margin_end@PLT
	movq	-88(%rbp), %rax
	movl	$10, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_margin_bottom@PLT
	call	gtk_overlay_get_type@PLT
	movq	%rax, %rdx
	movq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	movq	-88(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gtk_overlay_add_overlay@PLT
	movq	.LC9(%rip), %rdx
	movq	-88(%rbp), %rax
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	gtk_widget_set_opacity@PLT
	leaq	.LC10(%rip), %rax
	movq	%rax, %rdi
	call	gtk_button_new_with_label@PLT
	movq	%rax, -80(%rbp)
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-80(%rbp), %rax
	movl	$5, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	movq	-120(%rbp), %rdx
	movq	-80(%rbp), %rax
	movl	$0, %r9d
	movl	$0, %r8d
	movq	%rdx, %rcx
	movq	on_start_all_clicked@GOTPCREL(%rip), %rdx
	leaq	.LC11(%rip), %rsi
	movq	%rax, %rdi
	call	g_signal_connect_data@PLT
	leaq	.LC12(%rip), %rax
	movq	%rax, %rdi
	call	gtk_button_new_with_label@PLT
	movq	%rax, -72(%rbp)
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-72(%rbp), %rax
	movl	$5, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	movq	-120(%rbp), %rdx
	movq	-72(%rbp), %rax
	movl	$0, %r9d
	movl	$0, %r8d
	movq	%rdx, %rcx
	movq	on_stop_all_clicked@GOTPCREL(%rip), %rdx
	leaq	.LC11(%rip), %rsi
	movq	%rax, %rdi
	call	g_signal_connect_data@PLT
	leaq	.LC13(%rip), %rax
	movq	%rax, %rdi
	call	gtk_label_new@PLT
	movq	%rax, -64(%rbp)
	call	gtk_entry_new@PLT
	movq	%rax, -56(%rbp)
	call	gtk_entry_get_type@PLT
	movq	%rax, %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC14(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gtk_entry_set_text@PLT
	movq	-128(%rbp), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rcx
	movq	-56(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC15(%rip), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	g_object_set_data@PLT
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-64(%rbp), %rax
	movl	$5, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-56(%rbp), %rax
	movl	$5, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	movq	-120(%rbp), %rdx
	movq	-56(%rbp), %rax
	movl	$0, %r9d
	movl	$0, %r8d
	movq	%rdx, %rcx
	movq	on_global_duration_changed@GOTPCREL(%rip), %rdx
	leaq	.LC16(%rip), %rsi
	movq	%rax, %rdi
	call	g_signal_connect_data@PLT
	leaq	.LC17(%rip), %rax
	movq	%rax, %rdi
	call	gtk_button_new_with_label@PLT
	movq	%rax, -48(%rbp)
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-48(%rbp), %rax
	movl	$5, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	movq	-48(%rbp), %rax
	movl	$0, %r9d
	movl	$0, %r8d
	movl	$0, %ecx
	leaq	on_close_clicked(%rip), %rdx
	leaq	.LC11(%rip), %rsi
	movq	%rax, %rdi
	call	g_signal_connect_data@PLT
	call	gtk_notebook_get_type@PLT
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rcx
	movq	-96(%rbp), %rdx
	movq	-112(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	gtk_notebook_append_page@PLT
	movq	-128(%rbp), %rax
	movl	$0, %r9d
	movl	$0, %r8d
	movl	$0, %ecx
	leaq	on_close_clicked(%rip), %rdx
	leaq	.LC18(%rip), %rsi
	movq	%rax, %rdi
	call	g_signal_connect_data@PLT
	call	g_socket_service_new@PLT
	movq	%rax, global_service(%rip)
	movl	$2, %edi
	call	g_inet_address_new_any@PLT
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movl	$8080, %esi
	movq	%rax, %rdi
	call	g_inet_socket_address_new@PLT
	movq	%rax, -32(%rbp)
	call	g_socket_listener_get_type@PLT
	movq	%rax, %rdx
	movq	global_service(%rip), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-32(%rbp), %rax
	subq	$8, %rsp
	pushq	$0
	movl	$0, %r9d
	movl	$0, %r8d
	movl	$6, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	call	g_socket_listener_add_address@PLT
	addq	$16, %rsp
	movl	%eax, -140(%rbp)
	cmpl	$0, -140(%rbp)
	jne	.L31
	leaq	.LC19(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	g_printerr@PLT
	movl	$1, %eax
	jmp	.L36
.L31:
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	g_object_unref@PLT
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	g_object_unref@PLT
	movq	global_service(%rip), %rax
	movq	-120(%rbp), %rdx
	movl	$0, %r9d
	movl	$0, %r8d
	movq	%rdx, %rcx
	movq	on_client_incoming@GOTPCREL(%rip), %rdx
	leaq	.LC20(%rip), %rsi
	movq	%rax, %rdi
	call	g_signal_connect_data@PLT
	movq	global_service(%rip), %rax
	movq	%rax, %rdi
	call	g_socket_service_start@PLT
	movl	$0, %eax
	call	detect_hotspot_ip
	movl	%eax, -136(%rbp)
	movl	-136(%rbp), %eax
	movl	%eax, %edi
	call	compute_broadcast
	movl	%eax, -132(%rbp)
	movl	$20, %esi
	movl	$1, %edi
	call	g_malloc0_n@PLT
	movq	%rax, broadcast_info(%rip)
	movq	broadcast_info(%rip), %rbx
	movl	$0, %edx
	movl	$2, %esi
	movl	$2, %edi
	call	socket@PLT
	movl	%eax, (%rbx)
	movq	broadcast_info(%rip), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jns	.L33
	leaq	.LC21(%rip), %rax
	movq	%rax, %rdx
	movl	$4, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	g_log@PLT
.L34:
	nop
	jmp	.L34
.L33:
	movl	$1, -144(%rbp)
	movq	broadcast_info(%rip), %rax
	movl	(%rax), %eax
	leaq	-144(%rbp), %rdx
	movl	$4, %r8d
	movq	%rdx, %rcx
	movl	$6, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	setsockopt@PLT
	testl	%eax, %eax
	jns	.L35
	movq	broadcast_info(%rip), %rax
	addq	$4, %rax
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
.L35:
	movq	broadcast_info(%rip), %rax
	movw	$2, 4(%rax)
	movq	broadcast_info(%rip), %rbx
	movl	$5000, %edi
	call	htons@PLT
	movw	%ax, 6(%rbx)
	movq	broadcast_info(%rip), %rbx
	movl	-132(%rbp), %eax
	movl	%eax, %edi
	call	htonl@PLT
	movl	%eax, 8(%rbx)
	movq	broadcast_info(%rip), %rax
	movq	%rax, %rdx
	leaq	broadcast_callback(%rip), %rax
	movq	%rax, %rsi
	movl	$5000, %edi
	call	g_timeout_add@PLT
	movq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	gtk_widget_show_all@PLT
	call	gtk_main@PLT
	movl	$0, %eax
.L36:
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L37
	call	__stack_chk_fail@PLT
.L37:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2451:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC9:
	.long	0
	.long	1072168960
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
