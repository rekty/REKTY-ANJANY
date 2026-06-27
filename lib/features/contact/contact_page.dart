import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_shadow.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/supabase_service.dart';
import '../../shared/layout/app_scaffold.dart';
import '../../shared/layout/responsive_container.dart';
import '../../shared/layout/section_title.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: Column(
        children: [
          _ContactHeader(),
          _ContactBody(),
          SizedBox(height: AppSpacing.hero),
        ],
      ),
    );
  }
}

class _ContactHeader extends StatelessWidget {
  const _ContactHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.hero),
      child: const ResponsiveContainer(
        child: SectionTitle(
          title: 'Contact Us',
          subtitle:
              'Have questions, feedback, or want to collaborate? We\'d love to hear from you.',
        ),
      ),
    );
  }
}

class _ContactBody extends StatelessWidget {
  const _ContactBody();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return ResponsiveContainer(
      child: isMobile
          ? const Column(
              children: [
                _ContactInfoPanel(),
                SizedBox(height: AppSpacing.xxxl),
                _FullContactForm(),
              ],
            )
          : const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: _ContactInfoPanel()),
                SizedBox(width: AppSpacing.giant),
                Expanded(flex: 6, child: _FullContactForm()),
              ],
            ),
    );
  }
}

class _ContactInfoPanel extends StatelessWidget {
  const _ContactInfoPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get in Touch',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          'Feel free to reach out through any of these channels.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.6,
          ),
        ),
        SizedBox(height: AppSpacing.xxxl),
        _ContactCard(
          icon: Icons.email_rounded,
          label: 'Email',
          value: 'rekty.anjany@gmail.com',
          color: Color(0xFF54C5F8),
        ),
        SizedBox(height: AppSpacing.xl),
        _ContactCard(
          icon: Icons.language_rounded,
          label: 'Website',
          value: 'rektyanjany.com',
          color: Color(0xFF34D399),
        ),
        SizedBox(height: AppSpacing.xl),
        _ContactCard(
          icon: Icons.telegram_rounded,
          label: 'Telegram',
          value: '@rektyanjany',
          color: Color(0xFF54C5F8),
        ),
        SizedBox(height: AppSpacing.xl),
        _ContactCard(
          icon: Icons.code_rounded,
          label: 'GitHub',
          value: 'github.com/rekty',
          color: AppColors.textPrimary,
        ),
      ],
    );
  }
}

class _ContactCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: _hover
                ? widget.color.withValues(alpha: .35)
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: .12),
                borderRadius: AppRadius.card,
                border:
                    Border.all(color: widget.color.withValues(alpha: .20)),
              ),
              child: Icon(widget.icon, color: widget.color, size: 20),
            ),

            const SizedBox(width: AppSpacing.lg),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FullContactForm extends StatefulWidget {
  const _FullContactForm();

  @override
  State<_FullContactForm> createState() => _FullContactFormState();
}

class _FullContactFormState extends State<_FullContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _supabase = SupabaseService.instance;
  bool _sending = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _sending = true;
      _error = null;
    });

    try {
      await _supabase.submitContactMessage(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
      );

      setState(() {
        _sending = false;
        _sent = true;
      });

      // Clear form
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    } catch (e) {
      setState(() {
        _sending = false;
        _error = e.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: $_error'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadow.card,
      ),
      child: _sent
          ? _buildSuccess()
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Send a Message',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            labelStyle:
                                TextStyle(color: AppColors.textSecondary),
                            prefixIcon: Icon(Icons.person_rounded,
                                color: AppColors.textSecondary),
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Required'
                              : null,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: AppColors.textPrimary),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle:
                                TextStyle(color: AppColors.textSecondary),
                            prefixIcon: Icon(Icons.email_rounded,
                                color: AppColors.textSecondary),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (!v.contains('@')) return 'Invalid email';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  TextFormField(
                    controller: _subjectController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      prefixIcon: Icon(Icons.subject_rounded,
                          color: AppColors.textSecondary),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  TextFormField(
                    controller: _messageController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 100),
                        child: Icon(Icons.message_rounded,
                            color: AppColors.textSecondary),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _sending ? null : _submit,
                      icon: _sending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Icon(Icons.send_rounded),
                      label: Text(_sending ? 'Sending...' : 'Send Message'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSuccess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.massive),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: .12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_rounded,
              color: AppColors.success, size: 44),
        ),
        const SizedBox(height: AppSpacing.xxl),
        const Text(
          'Message Sent!',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          'Thank you for reaching out.\nWe\'ll respond within 24 hours.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: AppSpacing.massive),
      ],
    );
  }
}
