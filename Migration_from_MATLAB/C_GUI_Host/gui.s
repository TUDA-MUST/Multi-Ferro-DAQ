	.file	"gui.c"
	.text
	.globl	waiting_tabs
	.bss
	.align 8
	.type	waiting_tabs, @object
	.size	waiting_tabs, 8
waiting_tabs:
	.zero	8
	.globl	queue_lock
	.align 8
	.type	queue_lock, @object
	.size	queue_lock, 8
queue_lock:
	.zero	8
	.section	.rodata
.LC0:
	.string	"plot_area"
.LC1:
	.string	"draw"
.LC2:
	.string	"global_dur_entry"
.LC3:
	.string	"300"
.LC4:
	.string	"Global Duration (seconds)"
.LC5:
	.string	"dur_entry"
.LC6:
	.string	"Load JSON Settings..."
.LC7:
	.string	"clicked"
.LC8:
	.string	"Start Measurement"
.LC9:
	.string	"Stop Measurement"
.LC10:
	.string	"stop_btn"
.LC11:
	.string	"Export to CSV"
.LC12:
	.string	"export_btn"
.LC13:
	.string	"Y-Min for Live Plot"
.LC14:
	.string	"-2500"
.LC15:
	.string	"Y-Max for Live Plot"
.LC16:
	.string	"2500"
.LC17:
	.string	"ymin_entry"
.LC18:
	.string	"ymax_entry"
.LC19:
	.string	"DISCONNECTED"
	.text
	.globl	build_client_ui
	.type	build_client_ui, @function
build_client_ui:
.LFB2446:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$208, %rsp
	movq	%rdi, -200(%rbp)
	movq	%rsi, -208(%rbp)
	cmpq	$0, -200(%rbp)
	je	.L8
	cmpq	$0, -208(%rbp)
	je	.L8
	movq	-200(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -168(%rbp)
	movl	$10, %esi
	movl	$0, %edi
	call	gtk_box_new@PLT
	movq	%rax, -160(%rbp)
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-168(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-160(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	movl	$0, %esi
	movl	$0, %edi
	call	gtk_scrolled_window_new@PLT
	movq	%rax, -152(%rbp)
	call	gtk_scrolled_window_get_type@PLT
	movq	%rax, %rdx
	movq	-152(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movl	$1, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	gtk_scrolled_window_set_policy@PLT
	movq	-152(%rbp), %rax
	movl	$-1, %edx
	movl	$300, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_size_request@PLT
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-160(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-152(%rbp), %rax
	movl	$10, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	movl	$10, %esi
	movl	$1, %edi
	call	gtk_box_new@PLT
	movq	%rax, -144(%rbp)
	call	gtk_container_get_type@PLT
	movq	%rax, %rdx
	movq	-152(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	movq	-144(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gtk_container_add@PLT
	movq	-200(%rbp), %rax
	movq	-144(%rbp), %rdx
	movq	%rdx, 24(%rax)
	movl	$10, %esi
	movl	$1, %edi
	call	gtk_box_new@PLT
	movq	%rax, -136(%rbp)
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-160(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-136(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	call	gtk_drawing_area_new@PLT
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	movl	$400, %edx
	movl	$800, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_size_request@PLT
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-136(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-128(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	movq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	gtk_widget_show@PLT
	movq	-200(%rbp), %rax
	movq	16(%rax), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rcx
	movq	-128(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC0(%rip), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	g_object_set_data@PLT
	movq	-200(%rbp), %rdx
	movq	-128(%rbp), %rax
	movl	$0, %r9d
	movl	$0, %r8d
	movq	%rdx, %rcx
	leaq	on_plot_draw(%rip), %rdx
	leaq	.LC1(%rip), %rsi
	movq	%rax, %rdi
	call	g_signal_connect_data@PLT
	movl	$0, %esi
	movl	$0, %edi
	call	gtk_scrolled_window_new@PLT
	movq	%rax, -120(%rbp)
	call	gtk_scrolled_window_get_type@PLT
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	gtk_scrolled_window_set_policy@PLT
	movq	-120(%rbp), %rax
	movl	$-1, %edx
	movl	$300, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_size_request@PLT
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-160(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-120(%rbp), %rax
	movl	$10, %r8d
	movl	$0, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_end@PLT
	movl	$10, %esi
	movl	$1, %edi
	call	gtk_box_new@PLT
	movq	%rax, -112(%rbp)
	call	gtk_container_get_type@PLT
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	movq	-112(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gtk_container_add@PLT
	movq	-208(%rbp), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC2(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	g_object_get_data@PLT
	movq	%rax, -104(%rbp)
	leaq	.LC3(%rip), %rax
	movq	%rax, -176(%rbp)
	cmpq	$0, -104(%rbp)
	je	.L5
	call	gtk_entry_get_type@PLT
	movq	%rax, %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	call	gtk_entry_get_text@PLT
	movq	%rax, -176(%rbp)
.L5:
	movq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movslq	%eax, %rdx
	movq	-200(%rbp), %rax
	movq	%rdx, 72(%rax)
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	gtk_label_new@PLT
	movq	%rax, -96(%rbp)
	call	gtk_entry_new@PLT
	movq	%rax, -88(%rbp)
	call	gtk_entry_get_type@PLT
	movq	%rax, %rdx
	movq	-88(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	movq	-176(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gtk_entry_set_text@PLT
	call	gtk_editable_get_type@PLT
	movq	%rax, %rdx
	movq	-88(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movl	$0, %esi
	movq	%rax, %rdi
	call	gtk_editable_set_editable@PLT
	movq	-88(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_sensitive@PLT
	movq	-200(%rbp), %rax
	movq	16(%rax), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rcx
	movq	-88(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC5(%rip), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	g_object_set_data@PLT
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-144(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-96(%rbp), %rax
	movl	$3, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-144(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-88(%rbp), %rax
	movl	$3, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	gtk_button_new_with_label@PLT
	movq	%rax, -80(%rbp)
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-112(%rbp), %rax
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
	movq	-200(%rbp), %rdx
	movq	-80(%rbp), %rax
	movl	$0, %r9d
	movl	$0, %r8d
	movq	%rdx, %rcx
	leaq	on_load_json_clicked(%rip), %rdx
	leaq	.LC7(%rip), %rsi
	movq	%rax, %rdi
	call	g_signal_connect_data@PLT
	movl	$0, -180(%rbp)
	jmp	.L6
.L7:
	movq	-200(%rbp), %rax
	movq	56(%rax), %rax
	movq	16(%rax), %rax
	movq	(%rax), %rax
	movl	-180(%rbp), %edx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rdx
	movq	-144(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	create_dynamic_widget@PLT
	addl	$1, -180(%rbp)
.L6:
	movq	-200(%rbp), %rax
	movq	56(%rax), %rax
	movq	16(%rax), %rax
	movl	8(%rax), %eax
	cmpl	%eax, -180(%rbp)
	jb	.L7
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	gtk_button_new_with_label@PLT
	movq	%rax, -72(%rbp)
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-112(%rbp), %rax
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
	movq	-200(%rbp), %rdx
	movq	-72(%rbp), %rax
	movl	$0, %r9d
	movl	$0, %r8d
	movq	%rdx, %rcx
	leaq	on_send_btn_clicked(%rip), %rdx
	leaq	.LC7(%rip), %rsi
	movq	%rax, %rdi
	call	g_signal_connect_data@PLT
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	gtk_button_new_with_label@PLT
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_sensitive@PLT
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-112(%rbp), %rax
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
	movq	-200(%rbp), %rax
	movq	16(%rax), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rcx
	movq	-64(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC10(%rip), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	g_object_set_data@PLT
	movq	-200(%rbp), %rdx
	movq	-64(%rbp), %rax
	movl	$0, %r9d
	movl	$0, %r8d
	movq	%rdx, %rcx
	leaq	on_stop_btn_clicked(%rip), %rdx
	leaq	.LC7(%rip), %rsi
	movq	%rax, %rdi
	call	g_signal_connect_data@PLT
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	call	gtk_button_new_with_label@PLT
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_sensitive@PLT
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-112(%rbp), %rax
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
	movq	-200(%rbp), %rdx
	movq	-56(%rbp), %rax
	movl	$0, %r9d
	movl	$0, %r8d
	movq	%rdx, %rcx
	leaq	on_export_csv_clicked(%rip), %rdx
	leaq	.LC7(%rip), %rsi
	movq	%rax, %rdi
	call	g_signal_connect_data@PLT
	movq	-200(%rbp), %rax
	movq	16(%rax), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rcx
	movq	-56(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC12(%rip), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	g_object_set_data@PLT
	leaq	.LC13(%rip), %rax
	movq	%rax, %rdi
	call	gtk_label_new@PLT
	movq	%rax, -48(%rbp)
	call	gtk_entry_new@PLT
	movq	%rax, -40(%rbp)
	call	gtk_entry_get_type@PLT
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC14(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gtk_entry_set_text@PLT
	leaq	.LC15(%rip), %rax
	movq	%rax, %rdi
	call	gtk_label_new@PLT
	movq	%rax, -32(%rbp)
	call	gtk_entry_new@PLT
	movq	%rax, -24(%rbp)
	call	gtk_entry_get_type@PLT
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC16(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gtk_entry_set_text@PLT
	movq	-200(%rbp), %rax
	movq	16(%rax), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rcx
	movq	-40(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC17(%rip), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	g_object_set_data@PLT
	movq	-200(%rbp), %rax
	movq	16(%rax), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rcx
	movq	-24(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC18(%rip), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	g_object_set_data@PLT
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-48(%rbp), %rax
	movl	$3, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-40(%rbp), %rax
	movl	$3, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-32(%rbp), %rax
	movl	$3, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-24(%rbp), %rax
	movl	$3, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	leaq	.LC19(%rip), %rax
	movq	%rax, %rdi
	call	gtk_label_new@PLT
	movq	%rax, -16(%rbp)
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-16(%rbp), %rax
	movl	$5, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_end@PLT
	movq	-200(%rbp), %rax
	movq	-16(%rbp), %rdx
	movq	%rdx, 48(%rax)
	jmp	.L1
.L8:
	nop
.L1:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2446:
	.size	build_client_ui, .-build_client_ui
	.section	.rodata
	.align 8
.LC20:
	.string	"No waiting tabs available! Creating one automatically...\n"
.LC21:
	.string	"Unknown Client"
.LC22:
	.string	"%s"
.LC23:
	.string	"Remove Client"
.LC24:
	.string	"client_info"
	.text
	.globl	assign_client_to_waiting_tab
	.type	assign_client_to_waiting_tab, @function
assign_client_to_waiting_tab:
.LFB2447:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$144, %rsp
	movq	%rdi, -120(%rbp)
	movq	%rsi, -128(%rbp)
	movq	%rdx, -136(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	queue_lock(%rip), %rax
	movq	%rax, %rdi
	call	g_mutex_lock@PLT
	movq	waiting_tabs(%rip), %rax
	movq	%rax, %rdi
	call	g_queue_is_empty@PLT
	testl	%eax, %eax
	je	.L10
	leaq	queue_lock(%rip), %rax
	movq	%rax, %rdi
	call	g_mutex_unlock@PLT
	leaq	.LC20(%rip), %rax
	movq	%rax, %rdx
	movl	$16, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	g_log@PLT
	movq	-136(%rbp), %rax
	movq	%rax, %rdi
	call	create_waiting_tab@PLT
	movq	%rax, -112(%rbp)
	leaq	queue_lock(%rip), %rax
	movq	%rax, %rdi
	call	g_mutex_lock@PLT
	movq	waiting_tabs(%rip), %rax
	movq	-112(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_queue_push_tail@PLT
	leaq	queue_lock(%rip), %rax
	movq	%rax, %rdi
	call	g_mutex_unlock@PLT
	leaq	queue_lock(%rip), %rax
	movq	%rax, %rdi
	call	g_mutex_lock@PLT
.L10:
	movq	waiting_tabs(%rip), %rax
	movq	%rax, %rdi
	call	g_queue_pop_head@PLT
	movq	%rax, -104(%rbp)
	leaq	queue_lock(%rip), %rax
	movq	%rax, %rdi
	call	g_mutex_unlock@PLT
	cmpq	$0, -104(%rbp)
	je	.L18
	movq	-104(%rbp), %rax
	movb	$0, 68(%rax)
	movq	-104(%rbp), %rax
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L13
	movq	-104(%rbp), %rax
	movq	40(%rax), %rax
	movq	%rax, %rdi
	call	gtk_widget_destroy@PLT
	movq	-104(%rbp), %rax
	movq	$0, 40(%rax)
.L13:
	movq	-128(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L14
	movq	-128(%rbp), %rax
	movq	(%rax), %rax
	jmp	.L15
.L14:
	leaq	.LC21(%rip), %rax
.L15:
	leaq	-80(%rbp), %rdi
	movq	%rax, %rcx
	leaq	.LC22(%rip), %rax
	movq	%rax, %rdx
	movl	$64, %esi
	movl	$0, %eax
	call	snprintf@PLT
	call	gtk_label_get_type@PLT
	movq	%rax, %rdx
	movq	-104(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	-80(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gtk_label_set_text@PLT
	movq	-104(%rbp), %rax
	movq	8(%rax), %rax
	leaq	-80(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	set_tab_label_color_text@PLT
	movq	-120(%rbp), %rax
	movq	%rax, %rdi
	call	g_object_ref@PLT
	movq	-104(%rbp), %rdx
	movq	%rax, (%rdx)
	movq	-104(%rbp), %rax
	movq	-128(%rbp), %rdx
	movq	%rdx, 56(%rax)
	movq	-104(%rbp), %rax
	movq	%rax, %rdx
	movq	monitor_client_connection@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movl	$5000, %edi
	call	g_timeout_add@PLT
	movq	-104(%rbp), %rdx
	movl	%eax, 64(%rdx)
	leaq	.LC23(%rip), %rax
	movq	%rax, %rdi
	call	gtk_button_new_with_label@PLT
	movq	%rax, -96(%rbp)
	call	gtk_box_get_type@PLT
	movq	%rax, %rdx
	movq	-104(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	movq	-96(%rbp), %rax
	movl	$4, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	gtk_box_pack_start@PLT
	movq	-104(%rbp), %rdx
	movq	-96(%rbp), %rax
	movl	$0, %r9d
	movl	$0, %r8d
	movq	%rdx, %rcx
	leaq	on_remove_client_clicked(%rip), %rdx
	leaq	.LC7(%rip), %rsi
	movq	%rax, %rdi
	call	g_signal_connect_data@PLT
	movq	-136(%rbp), %rax
	movq	%rax, %rdi
	call	gtk_widget_get_toplevel@PLT
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	build_client_ui
	movq	-104(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, %rdi
	call	gtk_widget_show_all@PLT
	movq	-104(%rbp), %rax
	movq	16(%rax), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rcx
	movq	-104(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC24(%rip), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	g_object_set_data@PLT
	jmp	.L9
.L18:
	nop
.L9:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L17
	call	__stack_chk_fail@PLT
.L17:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2447:
	.size	assign_client_to_waiting_tab, .-assign_client_to_waiting_tab
	.globl	on_remove_client_clicked
	.type	on_remove_client_clicked, @function
on_remove_client_clicked:
.LFB2448:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free_client_info@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2448:
	.size	on_remove_client_clicked, .-on_remove_client_clicked
	.globl	on_close_waiting_tab_clicked
	.type	on_close_waiting_tab_clicked, @function
on_close_waiting_tab_clicked:
.LFB2449:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -16(%rbp)
	leaq	queue_lock(%rip), %rax
	movq	%rax, %rdi
	call	g_mutex_lock@PLT
	movq	waiting_tabs(%rip), %rax
	movq	-16(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_queue_find@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L21
	movq	waiting_tabs(%rip), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_queue_delete_link@PLT
.L21:
	leaq	queue_lock(%rip), %rax
	movq	%rax, %rdi
	call	g_mutex_unlock@PLT
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	free_client_info@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2449:
	.size	on_close_waiting_tab_clicked, .-on_close_waiting_tab_clicked
	.section	.rodata
.LC25:
	.string	"_Open"
.LC26:
	.string	"_Cancel"
.LC27:
	.string	"Load Settings JSON"
.LC28:
	.string	"Failed to load JSON settings."
.LC29:
	.string	"char[256]"
.LC30:
	.string	"float"
.LC31:
	.string	"%.6g"
.LC32:
	.string	"uint8"
.LC33:
	.string	"%u"
.LC34:
	.string	"uint32"
.LC35:
	.string	"uint64"
.LC36:
	.string	"%lu"
.LC37:
	.string	"int32"
.LC38:
	.string	"%d"
	.text
	.type	on_load_json_clicked, @function
on_load_json_clicked:
.LFB2450:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$248, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -248(%rbp)
	movq	%rsi, -256(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	pushq	$0
	pushq	$-3
	leaq	.LC25(%rip), %r9
	movl	$-6, %r8d
	leaq	.LC26(%rip), %rax
	movq	%rax, %rcx
	movl	$0, %edx
	movl	$0, %esi
	leaq	.LC27(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	gtk_file_chooser_dialog_new@PLT
	addq	$16, %rsp
	movq	%rax, -200(%rbp)
	call	gtk_dialog_get_type@PLT
	movq	%rax, %rdx
	movq	-200(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	call	gtk_dialog_run@PLT
	cmpl	$-3, %eax
	je	.L23
	movq	-200(%rbp), %rax
	movq	%rax, %rdi
	call	gtk_widget_destroy@PLT
	jmp	.L22
.L23:
	call	gtk_file_chooser_get_type@PLT
	movq	%rax, %rdx
	movq	-200(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	call	gtk_file_chooser_get_filename@PLT
	movq	%rax, -192(%rbp)
	movq	-200(%rbp), %rax
	movq	%rax, %rdi
	call	gtk_widget_destroy@PLT
	movq	-192(%rbp), %rdx
	movq	-256(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	parse_settings_from_json@PLT
	testl	%eax, %eax
	jne	.L25
	leaq	.LC28(%rip), %rax
	movq	%rax, %rdx
	movl	$16, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	g_log@PLT
	movq	-192(%rbp), %rax
	movq	%rax, %rdi
	call	g_free@PLT
	jmp	.L22
.L25:
	movq	-192(%rbp), %rax
	movq	%rax, %rdi
	call	g_free@PLT
	movl	$0, -236(%rbp)
	jmp	.L26
.L53:
	movq	-256(%rbp), %rax
	movq	56(%rax), %rax
	movq	16(%rax), %rax
	movq	(%rax), %rax
	movl	-236(%rbp), %edx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -184(%rbp)
	movq	-184(%rbp), %rax
	movq	(%rax), %rbx
	movq	-256(%rbp), %rax
	movq	16(%rax), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rbx, %rsi
	movq	%rax, %rdi
	call	g_object_get_data@PLT
	movq	%rax, -176(%rbp)
	cmpq	$0, -176(%rbp)
	je	.L55
	movq	-176(%rbp), %rax
	movq	%rax, -168(%rbp)
	call	gtk_entry_get_type@PLT
	movq	%rax, -160(%rbp)
	cmpq	$0, -168(%rbp)
	jne	.L29
	movl	$0, -232(%rbp)
	jmp	.L30
.L29:
	movq	-168(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L31
	movq	-168(%rbp), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	cmpq	%rax, -160(%rbp)
	jne	.L31
	movl	$1, -232(%rbp)
	jmp	.L30
.L31:
	movq	-160(%rbp), %rdx
	movq	-168(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_is_a@PLT
	movl	%eax, -232(%rbp)
.L30:
	movl	-232(%rbp), %eax
	testl	%eax, %eax
	je	.L32
	movq	-184(%rbp), %rax
	movq	24(%rax), %rax
	leaq	.LC29(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_strcmp0@PLT
	testl	%eax, %eax
	jne	.L33
	movq	-184(%rbp), %rax
	movq	32(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	g_variant_get_string@PLT
	movq	%rax, %rdx
	leaq	-96(%rbp), %rax
	movq	%rdx, %rcx
	leaq	.LC22(%rip), %rdx
	movl	$64, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	jmp	.L34
.L33:
	movq	-184(%rbp), %rax
	movq	24(%rax), %rax
	leaq	.LC30(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_strcmp0@PLT
	testl	%eax, %eax
	jne	.L35
	movq	-184(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	call	g_variant_get_double@PLT
	movq	%xmm0, %rax
	leaq	-96(%rbp), %rcx
	movq	%rax, %xmm0
	leaq	.LC31(%rip), %rax
	movq	%rax, %rdx
	movl	$64, %esi
	movq	%rcx, %rdi
	movl	$1, %eax
	call	snprintf@PLT
	jmp	.L34
.L35:
	movq	-184(%rbp), %rax
	movq	24(%rax), %rax
	leaq	.LC32(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_strcmp0@PLT
	testl	%eax, %eax
	jne	.L36
	movq	-184(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	call	g_variant_get_byte@PLT
	movzbl	%al, %edx
	leaq	-96(%rbp), %rax
	movl	%edx, %ecx
	leaq	.LC33(%rip), %rdx
	movl	$64, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	jmp	.L34
.L36:
	movq	-184(%rbp), %rax
	movq	24(%rax), %rax
	leaq	.LC34(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_strcmp0@PLT
	testl	%eax, %eax
	jne	.L37
	movq	-184(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	call	g_variant_get_uint32@PLT
	movl	%eax, %edx
	leaq	-96(%rbp), %rax
	movl	%edx, %ecx
	leaq	.LC33(%rip), %rdx
	movl	$64, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	jmp	.L34
.L37:
	movq	-184(%rbp), %rax
	movq	24(%rax), %rax
	leaq	.LC35(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_strcmp0@PLT
	testl	%eax, %eax
	jne	.L38
	movq	-184(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	call	g_variant_get_uint64@PLT
	movq	%rax, %rdx
	leaq	-96(%rbp), %rax
	movq	%rdx, %rcx
	leaq	.LC36(%rip), %rdx
	movl	$64, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	jmp	.L34
.L38:
	movq	-184(%rbp), %rax
	movq	24(%rax), %rax
	leaq	.LC37(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_strcmp0@PLT
	testl	%eax, %eax
	jne	.L34
	movq	-184(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	call	g_variant_get_int32@PLT
	movl	%eax, %edx
	leaq	-96(%rbp), %rax
	movl	%edx, %ecx
	leaq	.LC38(%rip), %rdx
	movl	$64, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.L34:
	call	gtk_entry_get_type@PLT
	movq	%rax, %rdx
	movq	-176(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	-96(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gtk_entry_set_text@PLT
	jmp	.L28
.L32:
	movq	-176(%rbp), %rax
	movq	%rax, -152(%rbp)
	call	gtk_combo_box_text_get_type@PLT
	movq	%rax, -144(%rbp)
	cmpq	$0, -152(%rbp)
	jne	.L39
	movl	$0, -228(%rbp)
	jmp	.L40
.L39:
	movq	-152(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L41
	movq	-152(%rbp), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	cmpq	%rax, -144(%rbp)
	jne	.L41
	movl	$1, -228(%rbp)
	jmp	.L40
.L41:
	movq	-144(%rbp), %rdx
	movq	-152(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_is_a@PLT
	movl	%eax, -228(%rbp)
.L40:
	movl	-228(%rbp), %eax
	testl	%eax, %eax
	je	.L28
	movq	$0, -208(%rbp)
	movq	-184(%rbp), %rax
	movq	24(%rax), %rax
	leaq	.LC29(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_strcmp0@PLT
	testl	%eax, %eax
	jne	.L42
	movq	-184(%rbp), %rax
	movq	32(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	g_variant_get_string@PLT
	movq	%rax, -208(%rbp)
	jmp	.L43
.L42:
	movq	-184(%rbp), %rax
	movq	24(%rax), %rax
	leaq	.LC30(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_strcmp0@PLT
	testl	%eax, %eax
	jne	.L44
	movq	-184(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	call	g_variant_get_double@PLT
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leaq	.LC31(%rip), %rax
	movq	%rax, %rdx
	movl	$64, %esi
	leaq	buf.0(%rip), %rax
	movq	%rax, %rdi
	movl	$1, %eax
	call	snprintf@PLT
	leaq	buf.0(%rip), %rax
	movq	%rax, -208(%rbp)
	jmp	.L43
.L44:
	movq	-184(%rbp), %rax
	movq	24(%rax), %rax
	leaq	.LC32(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_strcmp0@PLT
	testl	%eax, %eax
	jne	.L45
	movq	-184(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	call	g_variant_get_byte@PLT
	movzbl	%al, %eax
	movl	%eax, %ecx
	leaq	.LC33(%rip), %rax
	movq	%rax, %rdx
	movl	$64, %esi
	leaq	buf.0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	leaq	buf.0(%rip), %rax
	movq	%rax, -208(%rbp)
	jmp	.L43
.L45:
	movq	-184(%rbp), %rax
	movq	24(%rax), %rax
	leaq	.LC34(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_strcmp0@PLT
	testl	%eax, %eax
	jne	.L46
	movq	-184(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	call	g_variant_get_uint32@PLT
	movl	%eax, %ecx
	leaq	.LC33(%rip), %rax
	movq	%rax, %rdx
	movl	$64, %esi
	leaq	buf.0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	leaq	buf.0(%rip), %rax
	movq	%rax, -208(%rbp)
	jmp	.L43
.L46:
	movq	-184(%rbp), %rax
	movq	24(%rax), %rax
	leaq	.LC35(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_strcmp0@PLT
	testl	%eax, %eax
	jne	.L47
	movq	-184(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	call	g_variant_get_uint64@PLT
	movq	%rax, %rcx
	leaq	.LC36(%rip), %rax
	movq	%rax, %rdx
	movl	$64, %esi
	leaq	buf.0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	leaq	buf.0(%rip), %rax
	movq	%rax, -208(%rbp)
	jmp	.L43
.L47:
	movq	-184(%rbp), %rax
	movq	24(%rax), %rax
	leaq	.LC37(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_strcmp0@PLT
	testl	%eax, %eax
	jne	.L43
	movq	-184(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	call	g_variant_get_int32@PLT
	movl	%eax, %ecx
	leaq	.LC38(%rip), %rax
	movq	%rax, %rdx
	movl	$64, %esi
	leaq	buf.0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	leaq	buf.0(%rip), %rax
	movq	%rax, -208(%rbp)
.L43:
	call	gtk_combo_box_get_type@PLT
	movq	%rax, %rdx
	movq	-176(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	call	gtk_combo_box_get_model@PLT
	movq	%rax, -136(%rbp)
	leaq	-128(%rbp), %rdx
	movq	-136(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	gtk_tree_model_get_iter_first@PLT
	movl	%eax, -224(%rbp)
	movl	$0, -220(%rbp)
	jmp	.L48
.L52:
	movq	$0, -216(%rbp)
	leaq	-216(%rbp), %rdx
	leaq	-128(%rbp), %rsi
	movq	-136(%rbp), %rax
	movl	$-1, %r8d
	movq	%rdx, %rcx
	movl	$0, %edx
	movq	%rax, %rdi
	movl	$0, %eax
	call	gtk_tree_model_get@PLT
	movq	-216(%rbp), %rax
	testq	%rax, %rax
	je	.L49
	movq	-216(%rbp), %rax
	movq	-208(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L50
	call	gtk_combo_box_get_type@PLT
	movq	%rax, %rdx
	movq	-176(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	movl	-220(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	gtk_combo_box_set_active@PLT
	movq	-216(%rbp), %rax
	movq	%rax, %rdi
	call	g_free@PLT
	jmp	.L28
.L50:
	movq	-216(%rbp), %rax
	movq	%rax, %rdi
	call	g_free@PLT
.L49:
	leaq	-128(%rbp), %rdx
	movq	-136(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	gtk_tree_model_iter_next@PLT
	movl	%eax, -224(%rbp)
	addl	$1, -220(%rbp)
.L48:
	cmpl	$0, -224(%rbp)
	jne	.L52
	jmp	.L28
.L55:
	nop
.L28:
	addl	$1, -236(%rbp)
.L26:
	movq	-256(%rbp), %rax
	movq	56(%rax), %rax
	movq	16(%rax), %rax
	movl	8(%rax), %eax
	cmpl	%eax, -236(%rbp)
	jb	.L53
.L22:
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L54
	call	__stack_chk_fail@PLT
.L54:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2450:
	.size	on_load_json_clicked, .-on_load_json_clicked
	.section	.rodata
.LC39:
	.string	"measurement-reader"
	.text
	.type	on_send_btn_clicked, @function
on_send_btn_clicked:
.LFB2451:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	send_settings_to_client@PLT
	movq	-40(%rbp), %rax
	movq	120(%rax), %rax
	testq	%rax, %rax
	jne	.L63
	movq	-40(%rbp), %rax
	movq	16(%rax), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC10(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	g_object_get_data@PLT
	movq	%rax, -32(%rbp)
	cmpq	$0, -32(%rbp)
	je	.L59
	movq	-32(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_sensitive@PLT
.L59:
	movq	-40(%rbp), %rax
	movq	16(%rax), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC12(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	g_object_get_data@PLT
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	je	.L60
	movq	-24(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_sensitive@PLT
.L60:
	movq	-40(%rbp), %rax
	movq	56(%rax), %rax
	movq	%rax, %rdi
	call	get_sample_rate@PLT
	movl	%eax, -44(%rbp)
	movq	-40(%rbp), %rax
	movq	72(%rax), %rdx
	movl	-44(%rbp), %eax
	imulq	%rdx, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	addq	$4000, %rax
	movq	%rax, -8(%rbp)
	movq	-40(%rbp), %rax
	movq	104(%rax), %rax
	testq	%rax, %rax
	je	.L61
	movq	-40(%rbp), %rax
	movq	104(%rax), %rax
	movq	%rax, %rdi
	call	g_free@PLT
.L61:
	movq	-40(%rbp), %rax
	movq	80(%rax), %rax
	testq	%rax, %rax
	je	.L62
	movq	-40(%rbp), %rax
	movq	80(%rax), %rax
	movq	%rax, %rdi
	call	g_free@PLT
.L62:
	movq	-40(%rbp), %rax
	movq	56(%rax), %rax
	movq	8(%rax), %rax
	movl	(%rax), %eax
	movl	%eax, %eax
	imulq	-8(%rbp), %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	g_malloc0@PLT
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, 104(%rax)
	movq	-8(%rbp), %rax
	leaq	-1000(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, 112(%rax)
	movq	-40(%rbp), %rax
	movq	$0, 120(%rax)
	movq	-40(%rbp), %rax
	movq	72(%rax), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	leaq	10(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, 88(%rax)
	movq	-40(%rbp), %rax
	movq	88(%rax), %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdi
	call	g_malloc0@PLT
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, 80(%rax)
	movq	-40(%rbp), %rax
	movl	$1, 128(%rax)
	movq	-40(%rbp), %rax
	movq	%rax, %rdx
	leaq	measurement_thread_func(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC39(%rip), %rax
	movq	%rax, %rdi
	call	g_thread_new@PLT
	movq	-40(%rbp), %rdx
	movq	%rax, 136(%rdx)
	jmp	.L56
.L63:
	nop
.L56:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2451:
	.size	on_send_btn_clicked, .-on_send_btn_clicked
	.section	.rodata
	.align 8
.LC40:
	.string	"Failed to send STOP_PACKAGE: %s"
	.align 8
.LC41:
	.string	"Stop button widget not found for this tab"
.LC42:
	.string	"Measurement stopped by user."
	.text
	.type	on_stop_btn_clicked, @function
on_stop_btn_clicked:
.LFB2452:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movq	%rdi, -104(%rbp)
	movq	%rsi, -112(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-112(%rbp), %rax
	movq	%rax, -64(%rbp)
	cmpq	$0, -64(%rbp)
	je	.L79
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L79
	movq	-64(%rbp), %rax
	movl	$0, 128(%rax)
	movq	-64(%rbp), %rax
	movq	136(%rax), %rax
	testq	%rax, %rax
	je	.L68
	movq	-64(%rbp), %rax
	movq	136(%rax), %rax
	movq	%rax, %rdi
	call	g_thread_join@PLT
	movq	-64(%rbp), %rax
	movq	$0, 136(%rax)
.L68:
	movb	$1, -32(%rbp)
	movl	$0, -28(%rbp)
	movq	$0, -24(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	g_socket_connection_get_socket@PLT
	movq	%rax, -56(%rbp)
	cmpq	$0, -56(%rbp)
	je	.L80
	movzbl	-32(%rbp), %eax
	movb	%al, -13(%rbp)
	movl	-28(%rbp), %eax
	sall	$24, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	sall	$8, %eax
	andl	$16711680, %eax
	orl	%eax, %edx
	movl	-28(%rbp), %eax
	shrl	$8, %eax
	andl	$65280, %eax
	orl	%eax, %edx
	movl	-28(%rbp), %eax
	shrl	$24, %eax
	orl	%edx, %eax
	movl	%eax, -88(%rbp)
	leaq	-13(%rbp), %rax
	addq	$1, %rax
	movl	-88(%rbp), %edx
	movl	%edx, (%rax)
	movq	$0, -80(%rbp)
	leaq	-80(%rbp), %rdx
	leaq	-13(%rbp), %rsi
	movq	-56(%rbp), %rax
	movq	%rdx, %r8
	movl	$0, %ecx
	movl	$5, %edx
	movq	%rax, %rdi
	call	g_socket_send@PLT
	movq	-80(%rbp), %rax
	testq	%rax, %rax
	je	.L70
	movq	-80(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	leaq	.LC40(%rip), %rax
	movq	%rax, %rdx
	movl	$16, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	g_log@PLT
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	g_error_free@PLT
.L70:
	call	gtk_widget_get_type@PLT
	movq	%rax, %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, -72(%rbp)
	cmpq	$0, -72(%rbp)
	jne	.L71
	movq	-64(%rbp), %rax
	movq	16(%rax), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC10(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	g_object_get_data@PLT
	movq	%rax, -72(%rbp)
.L71:
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	call	gtk_widget_get_type@PLT
	movq	%rax, -40(%rbp)
	cmpq	$0, -48(%rbp)
	jne	.L72
	movl	$0, -84(%rbp)
	jmp	.L73
.L72:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L74
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	cmpq	%rax, -40(%rbp)
	jne	.L74
	movl	$1, -84(%rbp)
	jmp	.L73
.L74:
	movq	-40(%rbp), %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_is_a@PLT
	movl	%eax, -84(%rbp)
.L73:
	movl	-84(%rbp), %eax
	testl	%eax, %eax
	je	.L75
	movq	-72(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gtk_widget_set_sensitive@PLT
	jmp	.L76
.L75:
	leaq	.LC41(%rip), %rax
	movq	%rax, %rdx
	movl	$16, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	g_log@PLT
.L76:
	leaq	.LC42(%rip), %rax
	movq	%rax, %rdx
	movl	$32, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	g_log@PLT
	jmp	.L64
.L79:
	nop
	jmp	.L64
.L80:
	nop
.L64:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L78
	call	__stack_chk_fail@PLT
.L78:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2452:
	.size	on_stop_btn_clicked, .-on_stop_btn_clicked
	.section	.rodata
	.align 8
.LC43:
	.string	"Failed to send first PING_PACKAGE: %s"
	.text
	.globl	on_client_incoming
	.type	on_client_incoming, @function
on_client_incoming:
.LFB2453:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movq	%rdi, -88(%rbp)
	movq	%rsi, -96(%rbp)
	movq	%rdx, -104(%rbp)
	movq	%rcx, -112(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	call	gtk_widget_get_type@PLT
	movq	%rax, %rdx
	movq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, -48(%rbp)
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	g_socket_connection_get_socket@PLT
	movq	%rax, -40(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L82
	movl	$0, %eax
	jmp	.L87
.L82:
	leaq	-32(%rbp), %rcx
	movq	-40(%rbp), %rax
	movl	$150, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	get_next_tcp_package@PLT
	movl	%eax, -68(%rbp)
	cmpl	$0, -68(%rbp)
	jne	.L84
	movl	$0, %eax
	jmp	.L87
.L84:
	movzbl	-32(%rbp), %eax
	cmpb	$5, %al
	jne	.L85
	movl	-28(%rbp), %eax
	testl	%eax, %eax
	je	.L85
	movl	-28(%rbp), %eax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	parse_gui_config_from_json@PLT
	movq	%rax, -56(%rbp)
.L85:
	movb	$0, -32(%rbp)
	movl	$0, -28(%rbp)
	movq	$0, -24(%rbp)
	movzbl	-32(%rbp), %eax
	movb	%al, -13(%rbp)
	movl	-28(%rbp), %eax
	sall	$24, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	sall	$8, %eax
	andl	$16711680, %eax
	orl	%eax, %edx
	movl	-28(%rbp), %eax
	shrl	$8, %eax
	andl	$65280, %eax
	orl	%eax, %edx
	movl	-28(%rbp), %eax
	shrl	$24, %eax
	orl	%edx, %eax
	movl	%eax, -72(%rbp)
	leaq	-13(%rbp), %rax
	addq	$1, %rax
	movl	-72(%rbp), %edx
	movl	%edx, (%rax)
	movq	$0, -64(%rbp)
	leaq	-64(%rbp), %rdx
	leaq	-13(%rbp), %rsi
	movq	-40(%rbp), %rax
	movq	%rdx, %r8
	movl	$0, %ecx
	movl	$5, %edx
	movq	%rax, %rdi
	call	g_socket_send@PLT
	movq	-64(%rbp), %rax
	testq	%rax, %rax
	je	.L86
	movq	-64(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	leaq	.LC43(%rip), %rax
	movq	%rax, %rdx
	movl	$16, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	g_log@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	g_error_free@PLT
.L86:
	movq	-48(%rbp), %rdx
	movq	-56(%rbp), %rcx
	movq	-96(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	assign_client_to_waiting_tab
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	free_tcp_package@PLT
	movl	$1, %eax
.L87:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L88
	call	__stack_chk_fail@PLT
.L88:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2453:
	.size	on_client_incoming, .-on_client_incoming
	.section	.rodata
	.align 8
.LC44:
	.string	"No measurement data available.\n"
.LC45:
	.string	"%Y-%m-%d_%H-%M-%S_UTC"
.LC46:
	.string	"%s_%s.csv"
.LC47:
	.string	"_Save"
.LC48:
	.string	"Save CSV"
.LC49:
	.string	"w"
.LC50:
	.string	"Failed to open file %s\n"
.LC51:
	.string	"%s - %s\n"
	.align 8
.LC54:
	.string	"Starting linear regression for GLOBAL_TIME:"
.LC58:
	.string	"Pass 1: a=%.6f, b=%.6f\n"
	.align 8
.LC60:
	.string	"Inliers after 5ms filtering: %d / %d\n"
	.align 8
.LC61:
	.string	"Pass 2 (final): a=%.6f, b=%.6f\n"
.LC62:
	.string	"%Y-%m-%d %H:%M:%S"
	.align 8
.LC63:
	.string	"Sent Timesync request at %s.%03ld UTC, received echo at %s.%03ld UTC, local time %.1f\n"
.LC64:
	.string	"CHAN%d;"
.LC65:
	.string	"LOCAL_TIME;GLOBAL_TIME\n"
.LC66:
	.string	"%.6f"
.LC68:
	.string	";%s.%06d UTC\n"
.LC69:
	.string	"Data exported to %s\n"
	.text
	.type	on_export_csv_clicked, @function
on_export_csv_clicked:
.LFB2454:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$1112, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -1112(%rbp)
	movq	%rsi, -1120(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-1120(%rbp), %rax
	movq	%rax, -928(%rbp)
	movq	-928(%rbp), %rax
	movq	104(%rax), %rax
	testq	%rax, %rax
	je	.L90
	movq	-928(%rbp), %rax
	movq	120(%rax), %rax
	testq	%rax, %rax
	jne	.L91
.L90:
	leaq	.LC44(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	g_print@PLT
	jmp	.L89
.L91:
	call	gtk_label_get_type@PLT
	movq	%rax, %rdx
	movq	-928(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	call	gtk_label_get_text@PLT
	movq	%rax, -920(%rbp)
	movl	$0, %edi
	call	time@PLT
	movq	%rax, -1056(%rbp)
	leaq	-704(%rbp), %rdx
	leaq	-1056(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	gmtime_r@PLT
	leaq	-704(%rbp), %rdx
	leaq	-512(%rbp), %rax
	movq	%rdx, %rcx
	leaq	.LC45(%rip), %rdx
	movl	$64, %esi
	movq	%rax, %rdi
	call	strftime@PLT
	leaq	-512(%rbp), %rcx
	movq	-920(%rbp), %rdx
	leaq	-288(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	leaq	.LC46(%rip), %rdx
	movl	$256, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	leaq	-288(%rbp), %rax
	movq	%rax, -1048(%rbp)
	jmp	.L93
.L96:
	movq	-1048(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$32, %al
	je	.L94
	movq	-1048(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$58, %al
	je	.L94
	movq	-1048(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$47, %al
	je	.L94
	movq	-1048(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$92, %al
	je	.L94
	movq	-1048(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$42, %al
	je	.L94
	movq	-1048(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$63, %al
	je	.L94
	movq	-1048(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$34, %al
	je	.L94
	movq	-1048(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$60, %al
	je	.L94
	movq	-1048(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$62, %al
	je	.L94
	movq	-1048(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$124, %al
	jne	.L95
.L94:
	movq	-1048(%rbp), %rax
	movb	$95, (%rax)
.L95:
	addq	$1, -1048(%rbp)
.L93:
	movq	-1048(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L96
	call	gtk_window_get_type@PLT
	movq	%rax, %rbx
	call	gtk_widget_get_type@PLT
	movq	%rax, %rdx
	movq	-1112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	call	gtk_widget_get_toplevel@PLT
	movq	%rbx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rsi
	pushq	$0
	pushq	$-3
	leaq	.LC47(%rip), %r9
	movl	$-6, %r8d
	leaq	.LC26(%rip), %rax
	movq	%rax, %rcx
	movl	$1, %edx
	leaq	.LC48(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	gtk_file_chooser_dialog_new@PLT
	addq	$16, %rsp
	movq	%rax, -912(%rbp)
	call	gtk_file_chooser_get_type@PLT
	movq	%rax, %rdx
	movq	-912(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movl	$1, %esi
	movq	%rax, %rdi
	call	gtk_file_chooser_set_do_overwrite_confirmation@PLT
	call	gtk_file_chooser_get_type@PLT
	movq	%rax, %rdx
	movq	-912(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	-288(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gtk_file_chooser_set_current_name@PLT
	call	gtk_dialog_get_type@PLT
	movq	%rax, %rdx
	movq	-912(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	call	gtk_dialog_run@PLT
	cmpl	$-3, %eax
	je	.L97
	movq	-912(%rbp), %rax
	movq	%rax, %rdi
	call	gtk_widget_destroy@PLT
	jmp	.L89
.L97:
	call	gtk_file_chooser_get_type@PLT
	movq	%rax, %rdx
	movq	-912(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	call	gtk_file_chooser_get_filename@PLT
	movq	%rax, -904(%rbp)
	movq	-904(%rbp), %rax
	leaq	.LC49(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -896(%rbp)
	cmpq	$0, -896(%rbp)
	jne	.L98
	movq	-904(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC50(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	g_printerr@PLT
	movq	-904(%rbp), %rax
	movq	%rax, %rdi
	call	g_free@PLT
	movq	-912(%rbp), %rax
	movq	%rax, %rdi
	call	gtk_widget_destroy@PLT
	jmp	.L89
.L98:
	leaq	-512(%rbp), %rcx
	movq	-920(%rbp), %rdx
	movq	-896(%rbp), %rax
	leaq	.LC51(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-928(%rbp), %rax
	movq	96(%rax), %rax
	movl	%eax, -1064(%rbp)
	movl	-1064(%rbp), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -888(%rbp)
	movl	-1064(%rbp), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -880(%rbp)
	cmpl	$1, -1064(%rbp)
	jle	.L99
	movq	-928(%rbp), %rax
	movq	80(%rax), %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -720(%rbp)
	movq	%rdx, -712(%rbp)
	movq	-720(%rbp), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movq	-712(%rbp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC52(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -872(%rbp)
	movl	$0, -1092(%rbp)
	jmp	.L100
.L101:
	movq	-928(%rbp), %rax
	movq	80(%rax), %rcx
	movl	-1092(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	%rax, -752(%rbp)
	movq	-752(%rbp), %rax
	movq	(%rax), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movq	-752(%rbp), %rax
	movq	8(%rax), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC52(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -744(%rbp)
	movq	-752(%rbp), %rax
	movq	16(%rax), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movq	-752(%rbp), %rax
	movq	24(%rax), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC52(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -736(%rbp)
	movsd	-744(%rbp), %xmm0
	addsd	-736(%rbp), %xmm0
	movsd	.LC53(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -728(%rbp)
	movl	-1092(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-888(%rbp), %rax
	addq	%rdx, %rax
	movsd	-728(%rbp), %xmm0
	subsd	-872(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-752(%rbp), %rax
	movss	32(%rax), %xmm0
	movl	-1092(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-880(%rbp), %rax
	addq	%rdx, %rax
	cvtss2sd	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movl	-1092(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-880(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movq	-928(%rbp), %rax
	movq	80(%rax), %rax
	movss	32(%rax), %xmm1
	cvtss2sd	%xmm1, %xmm1
	movl	-1092(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-880(%rbp), %rax
	addq	%rdx, %rax
	subsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, -1092(%rbp)
.L100:
	movl	-1092(%rbp), %eax
	cmpl	-1064(%rbp), %eax
	jl	.L101
	leaq	.LC54(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -1040(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -1032(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -1024(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -1016(%rbp)
	movl	$0, -1088(%rbp)
	jmp	.L102
.L103:
	movl	-1088(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-888(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movsd	-1040(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -1040(%rbp)
	movl	-1088(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-880(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movsd	-1032(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -1032(%rbp)
	movl	-1088(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-888(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	movl	-1088(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-888(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-1024(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -1024(%rbp)
	movl	-1088(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-888(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	movl	-1088(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-880(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-1016(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -1016(%rbp)
	addl	$1, -1088(%rbp)
.L102:
	movl	-1088(%rbp), %eax
	cmpl	-1064(%rbp), %eax
	jl	.L103
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-1064(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	mulsd	-1024(%rbp), %xmm1
	movsd	-1040(%rbp), %xmm0
	movapd	%xmm0, %xmm2
	mulsd	%xmm0, %xmm2
	subsd	%xmm2, %xmm1
	movapd	%xmm1, %xmm0
	movsd	%xmm0, -864(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -1008(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -1000(%rbp)
	movsd	-864(%rbp), %xmm0
	movq	.LC56(%rip), %xmm1
	andpd	%xmm1, %xmm0
	comisd	.LC57(%rip), %xmm0
	jbe	.L104
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-1064(%rbp), %xmm0
	mulsd	-1016(%rbp), %xmm0
	movsd	-1040(%rbp), %xmm1
	mulsd	-1032(%rbp), %xmm1
	subsd	%xmm1, %xmm0
	divsd	-864(%rbp), %xmm0
	movsd	%xmm0, -1008(%rbp)
	movsd	-1032(%rbp), %xmm0
	mulsd	-1024(%rbp), %xmm0
	movsd	-1040(%rbp), %xmm1
	mulsd	-1016(%rbp), %xmm1
	subsd	%xmm1, %xmm0
	divsd	-864(%rbp), %xmm0
	movsd	%xmm0, -1000(%rbp)
.L104:
	movsd	-1000(%rbp), %xmm0
	movq	-1008(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	leaq	.LC58(%rip), %rax
	movq	%rax, %rdi
	movl	$2, %eax
	call	printf@PLT
	movsd	.LC59(%rip), %xmm0
	movsd	%xmm0, -856(%rbp)
	movl	-1064(%rbp), %eax
	cltq
	movl	$4, %esi
	movq	%rax, %rdi
	call	calloc@PLT
	movq	%rax, -848(%rbp)
	movl	$0, -1084(%rbp)
	movl	$0, -1080(%rbp)
	jmp	.L106
.L109:
	movl	-1080(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-888(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	mulsd	-1008(%rbp), %xmm0
	movsd	-1000(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -768(%rbp)
	movl	-1080(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-880(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	subsd	-768(%rbp), %xmm0
	movq	.LC56(%rip), %xmm1
	andpd	%xmm1, %xmm0
	movsd	%xmm0, -760(%rbp)
	movsd	-856(%rbp), %xmm0
	comisd	-760(%rbp), %xmm0
	jb	.L107
	movl	-1080(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-848(%rbp), %rax
	addq	%rdx, %rax
	movl	$1, (%rax)
	addl	$1, -1084(%rbp)
.L107:
	addl	$1, -1080(%rbp)
.L106:
	movl	-1080(%rbp), %eax
	cmpl	-1064(%rbp), %eax
	jl	.L109
	movl	-1064(%rbp), %edx
	movl	-1084(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC60(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -992(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -984(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -976(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -968(%rbp)
	movl	$0, -1076(%rbp)
	jmp	.L110
.L113:
	movl	-1076(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-848(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L131
	movl	-1076(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-888(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movsd	-992(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -992(%rbp)
	movl	-1076(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-880(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movsd	-984(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -984(%rbp)
	movl	-1076(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-888(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	movl	-1076(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-888(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-976(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -976(%rbp)
	movl	-1076(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-888(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	movl	-1076(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-880(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-968(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -968(%rbp)
	jmp	.L112
.L131:
	nop
.L112:
	addl	$1, -1076(%rbp)
.L110:
	movl	-1076(%rbp), %eax
	cmpl	-1064(%rbp), %eax
	jl	.L113
	movsd	-1008(%rbp), %xmm0
	movsd	%xmm0, -960(%rbp)
	movsd	-1000(%rbp), %xmm0
	movsd	%xmm0, -952(%rbp)
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-1084(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	mulsd	-976(%rbp), %xmm1
	movsd	-992(%rbp), %xmm0
	movapd	%xmm0, %xmm2
	mulsd	%xmm0, %xmm2
	subsd	%xmm2, %xmm1
	movapd	%xmm1, %xmm0
	movsd	%xmm0, -840(%rbp)
	cmpl	$1, -1084(%rbp)
	jle	.L114
	movsd	-840(%rbp), %xmm0
	movq	.LC56(%rip), %xmm1
	andpd	%xmm1, %xmm0
	comisd	.LC57(%rip), %xmm0
	jbe	.L114
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-1084(%rbp), %xmm0
	mulsd	-968(%rbp), %xmm0
	movsd	-992(%rbp), %xmm1
	mulsd	-984(%rbp), %xmm1
	subsd	%xmm1, %xmm0
	divsd	-840(%rbp), %xmm0
	movsd	%xmm0, -960(%rbp)
	movsd	-984(%rbp), %xmm0
	mulsd	-976(%rbp), %xmm0
	movsd	-992(%rbp), %xmm1
	mulsd	-968(%rbp), %xmm1
	subsd	%xmm1, %xmm0
	divsd	-840(%rbp), %xmm0
	movsd	%xmm0, -952(%rbp)
.L114:
	movsd	-952(%rbp), %xmm0
	movq	-960(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	leaq	.LC61(%rip), %rax
	movq	%rax, %rdi
	movl	$2, %eax
	call	printf@PLT
	movq	-848(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-928(%rbp), %rax
	movq	80(%rax), %rax
	testq	%rax, %rax
	je	.L116
	movq	-928(%rbp), %rax
	movq	96(%rax), %rax
	testq	%rax, %rax
	je	.L116
	movq	$0, -944(%rbp)
	jmp	.L117
.L118:
	movq	-928(%rbp), %rax
	movq	80(%rax), %rcx
	movq	-944(%rbp), %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	%rax, -832(%rbp)
	movq	-832(%rbp), %rax
	leaq	-640(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	gmtime_r@PLT
	movq	-832(%rbp), %rax
	leaq	16(%rax), %rdx
	leaq	-576(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gmtime_r@PLT
	leaq	-640(%rbp), %rdx
	leaq	-448(%rbp), %rax
	movq	%rdx, %rcx
	leaq	.LC62(%rip), %rdx
	movl	$80, %esi
	movq	%rax, %rdi
	call	strftime@PLT
	leaq	-576(%rbp), %rdx
	leaq	-368(%rbp), %rax
	movq	%rdx, %rcx
	leaq	.LC62(%rip), %rdx
	movl	$80, %esi
	movq	%rax, %rdi
	call	strftime@PLT
	movq	-832(%rbp), %rax
	movq	8(%rax), %rcx
	movabsq	$4835703278458516699, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	movq	%rdx, %rax
	sarq	$18, %rax
	sarq	$63, %rcx
	movq	%rcx, %rdx
	subq	%rdx, %rax
	movq	%rax, -824(%rbp)
	movq	-832(%rbp), %rax
	movq	24(%rax), %rcx
	movabsq	$4835703278458516699, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	movq	%rdx, %rax
	sarq	$18, %rax
	sarq	$63, %rcx
	movq	%rcx, %rdx
	subq	%rdx, %rax
	movq	%rax, -816(%rbp)
	movq	-832(%rbp), %rax
	movss	32(%rax), %xmm0
	pxor	%xmm3, %xmm3
	cvtss2sd	%xmm0, %xmm3
	movq	%xmm3, %rsi
	movq	-816(%rbp), %r8
	leaq	-368(%rbp), %rdi
	movq	-824(%rbp), %rcx
	leaq	-448(%rbp), %rdx
	movq	-896(%rbp), %rax
	movq	%rsi, %xmm0
	movq	%r8, %r9
	movq	%rdi, %r8
	leaq	.LC63(%rip), %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	addq	$1, -944(%rbp)
.L117:
	movq	-928(%rbp), %rax
	movq	96(%rax), %rax
	cmpq	%rax, -944(%rbp)
	jb	.L118
.L116:
	movl	$0, -1072(%rbp)
	jmp	.L119
.L120:
	movl	-1072(%rbp), %eax
	leal	1(%rax), %edx
	movq	-896(%rbp), %rax
	leaq	.LC64(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	addl	$1, -1072(%rbp)
.L119:
	movq	-928(%rbp), %rax
	movq	56(%rax), %rax
	movq	8(%rax), %rax
	movl	(%rax), %eax
	subl	$1, %eax
	movl	-1072(%rbp), %edx
	cmpl	%eax, %edx
	jb	.L120
	movq	-896(%rbp), %rax
	movq	%rax, %rcx
	movl	$23, %edx
	movl	$1, %esi
	leaq	.LC65(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movq	$0, -936(%rbp)
	jmp	.L121
.L125:
	movq	-928(%rbp), %rax
	movq	104(%rax), %rdx
	movq	-928(%rbp), %rax
	movq	56(%rax), %rax
	movq	8(%rax), %rax
	movl	(%rax), %eax
	movl	%eax, %eax
	imulq	-936(%rbp), %rax
	movq	%rax, %rcx
	movq	-928(%rbp), %rax
	movq	56(%rax), %rax
	movq	8(%rax), %rax
	movl	(%rax), %eax
	subl	$1, %eax
	movl	%eax, %eax
	addq	%rcx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	cvtss2sd	%xmm0, %xmm0
	movsd	%xmm0, -808(%rbp)
	movl	$0, -1068(%rbp)
	jmp	.L122
.L124:
	movq	-928(%rbp), %rax
	movq	104(%rax), %rdx
	movq	-928(%rbp), %rax
	movq	56(%rax), %rax
	movq	8(%rax), %rax
	movl	(%rax), %eax
	movl	%eax, %eax
	imulq	-936(%rbp), %rax
	movq	%rax, %rcx
	movl	-1068(%rbp), %eax
	cltq
	addq	%rcx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	pxor	%xmm4, %xmm4
	cvtss2sd	%xmm0, %xmm4
	movq	%xmm4, %rdx
	movq	-896(%rbp), %rax
	movq	%rdx, %xmm0
	leaq	.LC66(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	movq	-928(%rbp), %rax
	movq	56(%rax), %rax
	movq	8(%rax), %rax
	movl	(%rax), %eax
	subl	$1, %eax
	movl	-1068(%rbp), %edx
	cmpl	%eax, %edx
	jnb	.L123
	movq	-896(%rbp), %rax
	movq	%rax, %rsi
	movl	$59, %edi
	call	fputc@PLT
.L123:
	addl	$1, -1068(%rbp)
.L122:
	movq	-928(%rbp), %rax
	movq	56(%rax), %rax
	movq	8(%rax), %rax
	movl	(%rax), %eax
	movl	-1068(%rbp), %edx
	cmpl	%eax, %edx
	jb	.L124
	movq	-928(%rbp), %rax
	movq	80(%rax), %rax
	movss	32(%rax), %xmm0
	pxor	%xmm1, %xmm1
	cvtss2sd	%xmm0, %xmm1
	movsd	-808(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -800(%rbp)
	movsd	-800(%rbp), %xmm0
	subsd	-952(%rbp), %xmm0
	divsd	-960(%rbp), %xmm0
	movsd	%xmm0, -792(%rbp)
	movsd	-792(%rbp), %xmm0
	addsd	-872(%rbp), %xmm0
	movsd	%xmm0, -784(%rbp)
	movsd	-784(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, -640(%rbp)
	movq	-640(%rbp), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movsd	-784(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -776(%rbp)
	movsd	-776(%rbp), %xmm1
	movsd	.LC67(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	cvttsd2sil	%xmm0, %eax
	movl	%eax, -1060(%rbp)
	leaq	-576(%rbp), %rdx
	leaq	-640(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	gmtime_r@PLT
	leaq	-576(%rbp), %rdx
	leaq	-368(%rbp), %rax
	movq	%rdx, %rcx
	leaq	.LC62(%rip), %rdx
	movl	$64, %esi
	movq	%rax, %rdi
	call	strftime@PLT
	movl	-1060(%rbp), %ecx
	leaq	-368(%rbp), %rdx
	movq	-896(%rbp), %rax
	leaq	.LC68(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	addq	$1, -936(%rbp)
.L121:
	movq	-928(%rbp), %rax
	movq	120(%rax), %rax
	cmpq	%rax, -936(%rbp)
	jb	.L125
.L99:
	movq	-888(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-880(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-896(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	movq	-904(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC69(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	g_print@PLT
	movq	-904(%rbp), %rax
	movq	%rax, %rdi
	call	g_free@PLT
	movq	-912(%rbp), %rax
	movq	%rax, %rdi
	call	gtk_widget_destroy@PLT
.L89:
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L127
	call	__stack_chk_fail@PLT
.L127:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2454:
	.size	on_export_csv_clicked, .-on_export_csv_clicked
	.type	draw_text, @function
draw_text:
.LFB2455:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$96, %rsp
	movq	%rdi, -72(%rbp)
	movsd	%xmm0, -80(%rbp)
	movsd	%xmm1, -88(%rbp)
	movq	%rsi, -96(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-64(%rbp), %rdx
	movq	-96(%rbp), %rcx
	movq	-72(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	cairo_text_extents@PLT
	movsd	-40(%rbp), %xmm0
	movapd	%xmm0, %xmm3
	addsd	-88(%rbp), %xmm3
	movsd	-48(%rbp), %xmm0
	movsd	.LC53(%rip), %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movsd	-80(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	-72(%rbp), %rax
	movapd	%xmm3, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_move_to@PLT
	movq	-96(%rbp), %rdx
	movq	-72(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	cairo_show_text@PLT
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L133
	call	__stack_chk_fail@PLT
.L133:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2455:
	.size	draw_text, .-draw_text
	.section	.rodata
.LC76:
	.string	"Sans"
.LC80:
	.string	"%.2f"
.LC81:
	.string	"%.0f"
	.text
	.type	on_plot_draw, @function
on_plot_draw:
.LFB2456:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$576, %rsp
	movq	%rdi, -552(%rbp)
	movq	%rsi, -560(%rbp)
	movq	%rdx, -568(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-568(%rbp), %rax
	movq	%rax, -472(%rbp)
	cmpq	$0, -472(%rbp)
	je	.L135
	movq	-472(%rbp), %rax
	movq	104(%rax), %rax
	testq	%rax, %rax
	jne	.L136
.L135:
	movl	$0, %eax
	jmp	.L155
.L136:
	movq	-472(%rbp), %rax
	movq	120(%rax), %rax
	movq	%rax, -464(%rbp)
	cmpq	$0, -464(%rbp)
	jne	.L138
	movl	$0, %eax
	jmp	.L155
.L138:
	movq	-472(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -456(%rbp)
	movq	-456(%rbp), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC17(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	g_object_get_data@PLT
	movq	%rax, -448(%rbp)
	movq	-456(%rbp), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC18(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	g_object_get_data@PLT
	movq	%rax, -440(%rbp)
	movsd	.LC70(%rip), %xmm0
	movsd	%xmm0, -504(%rbp)
	movsd	.LC71(%rip), %xmm0
	movsd	%xmm0, -496(%rbp)
	cmpq	$0, -448(%rbp)
	je	.L139
	cmpq	$0, -440(%rbp)
	je	.L139
	call	gtk_entry_get_type@PLT
	movq	%rax, %rdx
	movq	-448(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	call	gtk_entry_get_text@PLT
	movq	%rax, -432(%rbp)
	call	gtk_entry_get_type@PLT
	movq	%rax, %rdx
	movq	-440(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	call	gtk_entry_get_text@PLT
	movq	%rax, -424(%rbp)
	movq	-432(%rbp), %rax
	movq	%rax, %rdi
	call	atof@PLT
	movq	%xmm0, %rax
	movq	%rax, -416(%rbp)
	movq	-424(%rbp), %rax
	movq	%rax, %rdi
	call	atof@PLT
	movq	%xmm0, %rax
	movq	%rax, -408(%rbp)
	movsd	-408(%rbp), %xmm0
	comisd	-416(%rbp), %xmm0
	jbe	.L139
	movsd	-416(%rbp), %xmm0
	movsd	%xmm0, -504(%rbp)
	movsd	-408(%rbp), %xmm0
	movsd	%xmm0, -496(%rbp)
.L139:
	movq	-472(%rbp), %rax
	movq	56(%rax), %rax
	movq	%rax, %rdi
	call	get_sample_rate@PLT
	movl	%eax, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	movl	%eax, %eax
	cmpq	-464(%rbp), %rax
	jnb	.L141
	movq	-472(%rbp), %rax
	movq	56(%rax), %rax
	movq	%rax, %rdi
	call	get_sample_rate@PLT
	movl	%eax, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	movl	%eax, %edx
	movq	-464(%rbp), %rax
	subq	%rdx, %rax
	jmp	.L142
.L141:
	movl	$0, %eax
.L142:
	movq	%rax, -400(%rbp)
	movq	-464(%rbp), %rax
	subq	-400(%rbp), %rax
	movq	%rax, -392(%rbp)
	leaq	-256(%rbp), %rdx
	movq	-552(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	gtk_widget_get_allocation@PLT
	movl	-248(%rbp), %eax
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	movsd	%xmm0, -384(%rbp)
	movl	-244(%rbp), %eax
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	movsd	%xmm0, -376(%rbp)
	movq	-472(%rbp), %rax
	movq	104(%rax), %rax
	movq	%rax, -368(%rbp)
	movq	-560(%rbp), %rax
	pxor	%xmm2, %xmm2
	pxor	%xmm1, %xmm1
	movq	.LC55(%rip), %rdx
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_set_source_rgb@PLT
	movq	-560(%rbp), %rax
	movq	%rax, %rdi
	call	cairo_paint@PLT
	movsd	.LC72(%rip), %xmm1
	movsd	.LC72(%rip), %xmm0
	movq	.LC72(%rip), %rdx
	movq	-560(%rbp), %rax
	movapd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_set_source_rgb@PLT
	movq	.LC72(%rip), %rdx
	movq	-560(%rbp), %rax
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_set_line_width@PLT
	movsd	-376(%rbp), %xmm0
	movsd	.LC73(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -360(%rbp)
	movsd	-360(%rbp), %xmm0
	movq	.LC74(%rip), %rdx
	movq	-560(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_move_to@PLT
	movsd	-384(%rbp), %xmm0
	movsd	.LC75(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movsd	-360(%rbp), %xmm0
	movq	-560(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_line_to@PLT
	movq	-560(%rbp), %rax
	movq	%rax, %rdi
	call	cairo_stroke@PLT
	movsd	.LC74(%rip), %xmm0
	movsd	%xmm0, -352(%rbp)
	movsd	.LC75(%rip), %xmm0
	movq	-352(%rbp), %rdx
	movq	-560(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_move_to@PLT
	movsd	-376(%rbp), %xmm0
	movsd	.LC73(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movq	-352(%rbp), %rdx
	movq	-560(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_line_to@PLT
	movq	-560(%rbp), %rax
	movq	%rax, %rdi
	call	cairo_stroke@PLT
	movq	-560(%rbp), %rax
	movl	$0, %ecx
	movl	$0, %edx
	leaq	.LC76(%rip), %rsi
	movq	%rax, %rdi
	call	cairo_select_font_face@PLT
	movq	.LC77(%rip), %rdx
	movq	-560(%rbp), %rax
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_set_font_size@PLT
	movq	-400(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	-472(%rbp), %rax
	movq	56(%rax), %rax
	movq	8(%rax), %rax
	movl	(%rax), %eax
	movl	%eax, %eax
	imulq	%rdx, %rax
	salq	$2, %rax
	leaq	-4(%rax), %rdx
	movq	-368(%rbp), %rax
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	cvtss2sd	%xmm0, %xmm0
	movsd	.LC67(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -344(%rbp)
	movq	-472(%rbp), %rax
	movq	56(%rax), %rax
	movq	8(%rax), %rax
	movl	(%rax), %eax
	movl	%eax, %eax
	imulq	-464(%rbp), %rax
	salq	$2, %rax
	leaq	-4(%rax), %rdx
	movq	-368(%rbp), %rax
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	cvtss2sd	%xmm0, %xmm0
	movsd	.LC67(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -336(%rbp)
	movsd	-336(%rbp), %xmm0
	subsd	-344(%rbp), %xmm0
	movsd	%xmm0, -488(%rbp)
	pxor	%xmm0, %xmm0
	comisd	-488(%rbp), %xmm0
	jb	.L143
	movsd	.LC78(%rip), %xmm0
	movsd	%xmm0, -488(%rbp)
.L143:
	movl	$10, -516(%rbp)
	movl	$0, -532(%rbp)
	jmp	.L145
.L146:
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-532(%rbp), %xmm0
	mulsd	-488(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-516(%rbp), %xmm1
	divsd	%xmm1, %xmm0
	movsd	-344(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -272(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-532(%rbp), %xmm1
	movsd	-384(%rbp), %xmm0
	subsd	-352(%rbp), %xmm0
	movsd	.LC75(%rip), %xmm2
	subsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-516(%rbp), %xmm1
	divsd	%xmm1, %xmm0
	movsd	-352(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -264(%rbp)
	movsd	-360(%rbp), %xmm0
	movq	-264(%rbp), %rdx
	movq	-560(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_move_to@PLT
	movsd	-360(%rbp), %xmm1
	movsd	.LC79(%rip), %xmm0
	addsd	%xmm1, %xmm0
	movq	-264(%rbp), %rdx
	movq	-560(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_line_to@PLT
	movq	-560(%rbp), %rax
	movq	%rax, %rdi
	call	cairo_stroke@PLT
	movq	-272(%rbp), %rdx
	leaq	-48(%rbp), %rax
	movq	%rdx, %xmm0
	leaq	.LC80(%rip), %rdx
	movl	$32, %esi
	movq	%rax, %rdi
	movl	$1, %eax
	call	snprintf@PLT
	movsd	-360(%rbp), %xmm1
	movsd	.LC75(%rip), %xmm0
	addsd	%xmm1, %xmm0
	leaq	-48(%rbp), %rcx
	movq	-264(%rbp), %rdx
	movq	-560(%rbp), %rax
	movq	%rcx, %rsi
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	draw_text
	addl	$1, -532(%rbp)
.L145:
	movl	-532(%rbp), %eax
	cmpl	-516(%rbp), %eax
	jle	.L146
	movl	$10, -512(%rbp)
	movsd	-496(%rbp), %xmm0
	subsd	-504(%rbp), %xmm0
	movsd	%xmm0, -328(%rbp)
	movl	$0, -528(%rbp)
	jmp	.L147
.L148:
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-528(%rbp), %xmm0
	mulsd	-328(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-512(%rbp), %xmm1
	divsd	%xmm1, %xmm0
	movsd	-504(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -288(%rbp)
	movsd	-288(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	subsd	-504(%rbp), %xmm1
	movsd	-360(%rbp), %xmm0
	movsd	.LC75(%rip), %xmm2
	subsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	movapd	%xmm0, %xmm1
	divsd	-328(%rbp), %xmm1
	movsd	-360(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -280(%rbp)
	movsd	-352(%rbp), %xmm0
	movsd	.LC79(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movsd	-280(%rbp), %xmm0
	movq	-560(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_move_to@PLT
	movsd	-280(%rbp), %xmm0
	movq	-352(%rbp), %rdx
	movq	-560(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_line_to@PLT
	movq	-560(%rbp), %rax
	movq	%rax, %rdi
	call	cairo_stroke@PLT
	movq	-288(%rbp), %rdx
	leaq	-48(%rbp), %rax
	movq	%rdx, %xmm0
	leaq	.LC81(%rip), %rdx
	movl	$32, %esi
	movq	%rax, %rdi
	movl	$1, %eax
	call	snprintf@PLT
	movsd	-280(%rbp), %xmm1
	movsd	.LC82(%rip), %xmm0
	addsd	%xmm1, %xmm0
	movq	.LC79(%rip), %rdx
	movq	-560(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_move_to@PLT
	leaq	-48(%rbp), %rdx
	movq	-560(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	cairo_show_text@PLT
	addl	$1, -528(%rbp)
.L147:
	movl	-528(%rbp), %eax
	cmpl	-512(%rbp), %eax
	jle	.L148
	movsd	.LC72(%rip), %xmm0
	movsd	%xmm0, -240(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -232(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -224(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -216(%rbp)
	movsd	.LC72(%rip), %xmm0
	movsd	%xmm0, -208(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -200(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -192(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -184(%rbp)
	movsd	.LC72(%rip), %xmm0
	movsd	%xmm0, -176(%rbp)
	movsd	.LC72(%rip), %xmm0
	movsd	%xmm0, -168(%rbp)
	movsd	.LC72(%rip), %xmm0
	movsd	%xmm0, -160(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -152(%rbp)
	movsd	.LC72(%rip), %xmm0
	movsd	%xmm0, -144(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -136(%rbp)
	movsd	.LC72(%rip), %xmm0
	movsd	%xmm0, -128(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -120(%rbp)
	movsd	.LC72(%rip), %xmm0
	movsd	%xmm0, -112(%rbp)
	movsd	.LC72(%rip), %xmm0
	movsd	%xmm0, -104(%rbp)
	movsd	.LC72(%rip), %xmm0
	movsd	%xmm0, -96(%rbp)
	movsd	.LC83(%rip), %xmm0
	movsd	%xmm0, -88(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -80(%rbp)
	movsd	.LC83(%rip), %xmm0
	movsd	%xmm0, -72(%rbp)
	movsd	.LC72(%rip), %xmm0
	movsd	%xmm0, -64(%rbp)
	movsd	.LC83(%rip), %xmm0
	movsd	%xmm0, -56(%rbp)
	movl	$0, -524(%rbp)
	jmp	.L149
.L154:
	movl	-524(%rbp), %edx
	movl	%edx, %eax
	sarl	$31, %eax
	shrl	$29, %eax
	addl	%eax, %edx
	andl	$7, %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movb	%al, -533(%rbp)
	movzbl	-533(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	%rbp, %rax
	subq	$224, %rax
	movsd	(%rax), %xmm1
	movzbl	-533(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	%rbp, %rax
	subq	$232, %rax
	movsd	(%rax), %xmm0
	movzbl	-533(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	%rbp, %rax
	subq	$240, %rax
	movq	(%rax), %rdx
	movq	-560(%rbp), %rax
	movapd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_set_source_rgb@PLT
	movq	.LC84(%rip), %rdx
	movq	-560(%rbp), %rax
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_set_line_width@PLT
	movl	$1, -520(%rbp)
	movq	$0, -480(%rbp)
	jmp	.L150
.L153:
	movq	-400(%rbp), %rdx
	movq	-480(%rbp), %rax
	addq	%rax, %rdx
	movq	-472(%rbp), %rax
	movq	56(%rax), %rax
	movq	8(%rax), %rax
	movl	(%rax), %eax
	movl	%eax, %eax
	imulq	%rdx, %rax
	movq	%rax, -320(%rbp)
	movl	-524(%rbp), %eax
	movslq	%eax, %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movq	-368(%rbp), %rax
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	movss	%xmm0, -508(%rbp)
	movq	-472(%rbp), %rax
	movq	56(%rax), %rax
	movq	8(%rax), %rax
	movl	(%rax), %eax
	movl	%eax, %edx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	salq	$2, %rax
	leaq	-4(%rax), %rdx
	movq	-368(%rbp), %rax
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	cvtss2sd	%xmm0, %xmm0
	movsd	.LC67(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -312(%rbp)
	movsd	-312(%rbp), %xmm0
	subsd	-344(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	divsd	-488(%rbp), %xmm1
	movsd	-384(%rbp), %xmm0
	subsd	-352(%rbp), %xmm0
	movsd	.LC75(%rip), %xmm2
	subsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-352(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -304(%rbp)
	pxor	%xmm0, %xmm0
	cvtss2sd	-508(%rbp), %xmm0
	subsd	-504(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	divsd	-328(%rbp), %xmm1
	movsd	-360(%rbp), %xmm0
	movsd	.LC75(%rip), %xmm2
	subsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-360(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -296(%rbp)
	cmpl	$0, -520(%rbp)
	je	.L151
	movsd	-296(%rbp), %xmm0
	movq	-304(%rbp), %rdx
	movq	-560(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_move_to@PLT
	movl	$0, -520(%rbp)
	jmp	.L152
.L151:
	movsd	-296(%rbp), %xmm0
	movq	-304(%rbp), %rdx
	movq	-560(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	movq	%rax, %rdi
	call	cairo_line_to@PLT
.L152:
	addq	$1, -480(%rbp)
.L150:
	movq	-480(%rbp), %rax
	cmpq	-392(%rbp), %rax
	jb	.L153
	movq	-560(%rbp), %rax
	movq	%rax, %rdi
	call	cairo_stroke@PLT
	addl	$1, -524(%rbp)
.L149:
	movq	-472(%rbp), %rax
	movq	56(%rax), %rax
	movq	8(%rax), %rax
	movl	(%rax), %eax
	subl	$1, %eax
	movl	-524(%rbp), %edx
	cmpl	%eax, %edx
	jb	.L154
	movl	$0, %eax
.L155:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L156
	call	__stack_chk_fail@PLT
.L156:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2456:
	.size	on_plot_draw, .-on_plot_draw
	.type	set_preamp_combo, @function
set_preamp_combo:
.LFB2457:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movq	%rdi, -104(%rbp)
	movl	%esi, -108(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-104(%rbp), %rax
	movq	%rax, -72(%rbp)
	call	gtk_combo_box_text_get_type@PLT
	movq	%rax, -64(%rbp)
	cmpq	$0, -72(%rbp)
	jne	.L160
	movl	$0, -92(%rbp)
	jmp	.L161
.L160:
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L162
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	cmpq	%rax, -64(%rbp)
	jne	.L162
	movl	$1, -92(%rbp)
	jmp	.L161
.L162:
	movq	-64(%rbp), %rdx
	movq	-72(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_is_a@PLT
	movl	%eax, -92(%rbp)
.L161:
	movl	-92(%rbp), %eax
	testl	%eax, %eax
	je	.L171
	call	gtk_combo_box_get_type@PLT
	movq	%rax, %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	call	gtk_combo_box_get_model@PLT
	movq	%rax, -56(%rbp)
	movl	$0, -84(%rbp)
	leaq	-48(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	gtk_tree_model_get_iter_first@PLT
	movl	%eax, -88(%rbp)
	jmp	.L165
.L168:
	movq	$0, -80(%rbp)
	leaq	-80(%rbp), %rdx
	leaq	-48(%rbp), %rsi
	movq	-56(%rbp), %rax
	movl	$-1, %r8d
	movq	%rdx, %rcx
	movl	$0, %edx
	movq	%rax, %rdi
	movl	$0, %eax
	call	gtk_tree_model_get@PLT
	movq	-80(%rbp), %rax
	testq	%rax, %rax
	je	.L166
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	cmpl	%eax, -108(%rbp)
	jne	.L167
	call	gtk_combo_box_get_type@PLT
	movq	%rax, %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	movl	-84(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	gtk_combo_box_set_active@PLT
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	g_free@PLT
	jmp	.L159
.L167:
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	g_free@PLT
.L166:
	leaq	-48(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	gtk_tree_model_iter_next@PLT
	movl	%eax, -88(%rbp)
	addl	$1, -84(%rbp)
.L165:
	cmpl	$0, -88(%rbp)
	jne	.L168
	jmp	.L159
.L171:
	nop
.L159:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L170
	call	__stack_chk_fail@PLT
.L170:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2457:
	.size	set_preamp_combo, .-set_preamp_combo
	.section	.rodata
	.align 8
.LC85:
	.string	"Memory allocation for buffer failed."
.LC86:
	.string	"unknown"
	.align 8
.LC87:
	.string	"Timestamp package send failed: %s"
	.align 8
.LC88:
	.string	"Measurement buffer full. Stopping measurement."
	.align 8
.LC89:
	.string	"ClientTime buffer full, cannot store more timestamps."
	.text
	.type	measurement_thread_func, @function
measurement_thread_func:
.LFB2458:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$176, %rsp
	movq	%rdi, -168(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-168(%rbp), %rax
	movq	%rax, -128(%rbp)
	cmpq	$0, -128(%rbp)
	je	.L173
	movq	-128(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L174
.L173:
	movl	$0, %eax
	jmp	.L175
.L174:
	movq	-128(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	g_socket_connection_get_socket@PLT
	movq	%rax, -120(%rbp)
	cmpq	$0, -120(%rbp)
	jne	.L176
	movl	$0, %eax
	jmp	.L175
.L176:
	movq	$0, -136(%rbp)
	jmp	.L177
.L197:
	movl	$0, %edi
	call	time@PLT
	movq	%rax, -112(%rbp)
	movq	-136(%rbp), %rdx
	movq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	difftime@PLT
	movq	%xmm0, %rax
	movq	%rax, %xmm1
	comisd	.LC79(%rip), %xmm1
	jb	.L178
	movq	-112(%rbp), %rax
	movq	%rax, -136(%rbp)
	leaq	-48(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	clock_gettime@PLT
	movb	$4, -32(%rbp)
	movl	$16, -28(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, %eax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	testq	%rax, %rax
	je	.L178
	movq	-24(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movl	-28(%rbp), %eax
	addl	$5, %eax
	movl	%eax, %eax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -104(%rbp)
	cmpq	$0, -104(%rbp)
	jne	.L181
	leaq	.LC85(%rip), %rax
	movq	%rax, %rdx
	movl	$16, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	g_log@PLT
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$0, %eax
	jmp	.L175
.L181:
	movzbl	-32(%rbp), %edx
	movq	-104(%rbp), %rax
	movb	%dl, (%rax)
	movl	-28(%rbp), %eax
	movl	%eax, %edi
	call	htonl@PLT
	movl	%eax, -152(%rbp)
	movq	-104(%rbp), %rax
	leaq	1(%rax), %rdx
	movl	-152(%rbp), %eax
	movl	%eax, (%rdx)
	movl	-28(%rbp), %eax
	movl	%eax, %esi
	movq	-24(%rbp), %rax
	movq	-104(%rbp), %rdx
	leaq	5(%rdx), %rcx
	movq	%rsi, %rdx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	memcpy@PLT
	movq	$0, -144(%rbp)
	movl	-28(%rbp), %eax
	addl	$5, %eax
	movl	%eax, %edi
	leaq	-144(%rbp), %rdx
	movq	-104(%rbp), %rsi
	movq	-120(%rbp), %rax
	movq	%rdx, %r8
	movl	$0, %ecx
	movq	%rdi, %rdx
	movq	%rax, %rdi
	call	g_socket_send@PLT
	movq	%rax, -96(%rbp)
	movl	-28(%rbp), %eax
	addl	$5, %eax
	movl	%eax, %eax
	cmpq	%rax, -96(%rbp)
	je	.L183
	movq	-144(%rbp), %rax
	testq	%rax, %rax
	je	.L184
	movq	-144(%rbp), %rax
	movq	8(%rax), %rax
	jmp	.L185
.L184:
	leaq	.LC86(%rip), %rax
.L185:
	movq	%rax, %rcx
	leaq	.LC87(%rip), %rax
	movq	%rax, %rdx
	movl	$16, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	g_log@PLT
	movq	-144(%rbp), %rax
	testq	%rax, %rax
	je	.L186
	movq	-144(%rbp), %rax
	movq	%rax, %rdi
	call	g_error_free@PLT
.L186:
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	disconnect_client@PLT
	movl	$0, %eax
	jmp	.L175
.L183:
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
.L178:
	leaq	-32(%rbp), %rcx
	movq	-120(%rbp), %rax
	movl	$150, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	get_next_tcp_package@PLT
	movl	%eax, -148(%rbp)
	cmpl	$0, -148(%rbp)
	jne	.L187
	movl	$2000, %edi
	call	g_usleep@PLT
	jmp	.L177
.L187:
	movzbl	-32(%rbp), %eax
	cmpb	$3, %al
	jne	.L189
	movl	-28(%rbp), %eax
	testl	%eax, %eax
	je	.L189
	movq	-128(%rbp), %rax
	movq	56(%rax), %rax
	movq	8(%rax), %rax
	movl	(%rax), %eax
	movl	%eax, %eax
	salq	$2, %rax
	movq	%rax, -88(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, %eax
	movl	$0, %edx
	divq	-88(%rbp)
	movq	%rax, -80(%rbp)
	movq	-128(%rbp), %rax
	movq	120(%rax), %rdx
	movq	-80(%rbp), %rax
	addq	%rax, %rdx
	movq	-128(%rbp), %rax
	movq	112(%rax), %rax
	cmpq	%rdx, %rax
	jnb	.L190
	leaq	.LC88(%rip), %rax
	movq	%rax, %rdx
	movl	$16, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	g_log@PLT
	movq	-128(%rbp), %rax
	movl	$0, 128(%rax)
	movq	-128(%rbp), %rax
	movq	16(%rax), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC10(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	g_object_get_data@PLT
	movq	%rax, -64(%rbp)
	cmpq	$0, -64(%rbp)
	je	.L191
	movq	-64(%rbp), %rax
	movq	%rax, %rsi
	leaq	on_stop_btn_clicked(%rip), %rax
	movq	%rax, %rdi
	call	g_idle_add@PLT
.L191:
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	free_tcp_package@PLT
	jmp	.L196
.L190:
	movq	-80(%rbp), %rax
	imulq	-88(%rbp), %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	-128(%rbp), %rcx
	movq	104(%rcx), %rdi
	movq	-128(%rbp), %rcx
	movq	120(%rcx), %rcx
	movq	-128(%rbp), %rsi
	movq	56(%rsi), %rsi
	movq	8(%rsi), %rsi
	movl	(%rsi), %esi
	movl	%esi, %esi
	imulq	%rsi, %rcx
	salq	$2, %rcx
	addq	%rdi, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	memcpy@PLT
	movq	-128(%rbp), %rax
	movq	120(%rax), %rdx
	movq	-80(%rbp), %rax
	addq	%rax, %rdx
	movq	-128(%rbp), %rax
	movq	%rdx, 120(%rax)
	movq	-128(%rbp), %rax
	movq	16(%rax), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC0(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	g_object_get_data@PLT
	movq	%rax, -72(%rbp)
	cmpq	$0, -72(%rbp)
	je	.L200
	movq	-72(%rbp), %rax
	movq	%rax, %rsi
	movq	gtk_widget_queue_draw@GOTPCREL(%rip), %rax
	movq	%rax, %rdi
	call	g_idle_add@PLT
	jmp	.L200
.L189:
	movzbl	-32(%rbp), %eax
	cmpb	$4, %al
	jne	.L194
	movl	-28(%rbp), %eax
	cmpl	$19, %eax
	jbe	.L194
	movq	-128(%rbp), %rax
	movq	96(%rax), %rdx
	movq	-128(%rbp), %rax
	movq	88(%rax), %rax
	cmpq	%rax, %rdx
	jnb	.L195
	movq	-128(%rbp), %rax
	movq	80(%rax), %rcx
	movq	-128(%rbp), %rax
	movq	96(%rax), %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	%rax, -56(%rbp)
	movq	-24(%rbp), %rax
	movq	-56(%rbp), %rcx
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-56(%rbp), %rax
	addq	$16, %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	clock_gettime@PLT
	movq	-24(%rbp), %rax
	addq	$16, %rax
	movl	(%rax), %eax
	movl	%eax, -48(%rbp)
	movss	-48(%rbp), %xmm0
	movq	-56(%rbp), %rax
	movss	%xmm0, 32(%rax)
	movq	-128(%rbp), %rax
	movq	96(%rax), %rax
	leaq	1(%rax), %rdx
	movq	-128(%rbp), %rax
	movq	%rdx, 96(%rax)
	jmp	.L194
.L195:
	leaq	.LC89(%rip), %rax
	movq	%rax, %rdx
	movl	$16, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	g_log@PLT
	jmp	.L194
.L200:
	nop
.L194:
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	free_tcp_package@PLT
.L177:
	movq	-128(%rbp), %rax
	movl	128(%rax), %eax
	testl	%eax, %eax
	je	.L196
	movq	-128(%rbp), %rax
	movzbl	68(%rax), %eax
	testb	%al, %al
	je	.L197
.L196:
	movl	$0, %eax
.L175:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L198
	call	__stack_chk_fail@PLT
.L198:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2458:
	.size	measurement_thread_func, .-measurement_thread_func
	.globl	on_start_all_clicked
	.type	on_start_all_clicked, @function
on_start_all_clicked:
.LFB2459:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	call	gtk_notebook_get_type@PLT
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	gtk_notebook_get_n_pages@PLT
	movl	%eax, -28(%rbp)
	movl	$1, -32(%rbp)
	jmp	.L202
.L205:
	movl	-32(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	gtk_notebook_get_nth_page@PLT
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC24(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	g_object_get_data@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L206
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	on_send_btn_clicked
	jmp	.L204
.L206:
	nop
.L204:
	addl	$1, -32(%rbp)
.L202:
	movl	-32(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L205
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2459:
	.size	on_start_all_clicked, .-on_start_all_clicked
	.section	.rodata
.LC90:
	.string	"Stopping client on tab %d...\n"
	.text
	.globl	on_stop_all_clicked
	.type	on_stop_all_clicked, @function
on_stop_all_clicked:
.LFB2460:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	call	gtk_notebook_get_type@PLT
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	gtk_notebook_get_n_pages@PLT
	movl	%eax, -28(%rbp)
	movl	$1, -32(%rbp)
	jmp	.L208
.L211:
	movl	-32(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	gtk_notebook_get_nth_page@PLT
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC24(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	g_object_get_data@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L212
	movl	-32(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC90(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	g_print@PLT
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	on_stop_btn_clicked
	jmp	.L210
.L212:
	nop
.L210:
	addl	$1, -32(%rbp)
.L208:
	movl	-32(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L211
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2460:
	.size	on_stop_all_clicked, .-on_stop_all_clicked
	.globl	on_global_duration_changed
	.type	on_global_duration_changed, @function
on_global_duration_changed:
.LFB2461:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	call	gtk_notebook_get_type@PLT
	movq	%rax, %rdx
	movq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, -40(%rbp)
	call	gtk_entry_get_type@PLT
	movq	%rax, %rdx
	movq	-72(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdi
	call	gtk_entry_get_text@PLT
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -48(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	gtk_notebook_get_n_pages@PLT
	movl	%eax, -44(%rbp)
	movl	$0, -52(%rbp)
	jmp	.L214
.L218:
	movl	-52(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	gtk_notebook_get_nth_page@PLT
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	je	.L219
	movq	-24(%rbp), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC24(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	g_object_get_data@PLT
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	je	.L220
	movl	-48(%rbp), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, 72(%rax)
	movq	-24(%rbp), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	leaq	.LC5(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	g_object_get_data@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L216
	call	gtk_entry_get_type@PLT
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	g_type_check_instance_cast@PLT
	movq	%rax, %rdx
	movq	-32(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	gtk_entry_set_text@PLT
	jmp	.L216
.L219:
	nop
	jmp	.L216
.L220:
	nop
.L216:
	addl	$1, -52(%rbp)
.L214:
	movl	-52(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L218
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2461:
	.size	on_global_duration_changed, .-on_global_duration_changed
	.local	buf.0
	.comm	buf.0,64,32
	.section	.rodata
	.align 8
.LC52:
	.long	0
	.long	1104006501
	.align 8
.LC53:
	.long	0
	.long	1073741824
	.align 8
.LC55:
	.long	0
	.long	0
	.align 16
.LC56:
	.long	-1
	.long	2147483647
	.long	0
	.long	0
	.align 8
.LC57:
	.long	-2127697391
	.long	1030854553
	.align 8
.LC59:
	.long	0
	.long	1085507584
	.align 8
.LC67:
	.long	0
	.long	1093567616
	.align 8
.LC70:
	.long	0
	.long	-1063024640
	.align 8
.LC71:
	.long	0
	.long	1084459008
	.align 8
.LC72:
	.long	0
	.long	1072693248
	.align 8
.LC73:
	.long	0
	.long	1077805056
	.align 8
.LC74:
	.long	0
	.long	1078198272
	.align 8
.LC75:
	.long	0
	.long	1076101120
	.align 8
.LC77:
	.long	0
	.long	1076363264
	.align 8
.LC78:
	.long	-400107883
	.long	1041313291
	.align 8
.LC79:
	.long	0
	.long	1075052544
	.align 8
.LC82:
	.long	0
	.long	1074790400
	.align 8
.LC83:
	.long	0
	.long	1071644672
	.align 8
.LC84:
	.long	858993459
	.long	1072902963
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
