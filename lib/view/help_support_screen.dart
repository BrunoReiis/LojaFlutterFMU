import 'package:flutter/material.dart';
import 'package:nexusstore/utils/app_textstyles.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<Map<String, String>> faqs = [
    {
      'question': 'Como faço para rastrear meu pedido?',
      'answer':
          'Você pode rastrear seu pedido na seção "Meus Pedidos" da sua conta. Lá você encontrará o status e informações de rastreamento.',
    },
    {
      'question': 'Qual é o prazo de entrega?',
      'answer':
          'O prazo de entrega varia de acordo com a localização. Geralmente, entregas são feitas entre 5 a 10 dias úteis após a confirmação do pedido.',
    },
    {
      'question': 'Como faço para devolver um produto?',
      'answer':
          'Para devolver um produto, acesse a seção "Meus Pedidos", selecione o item e clique em "Solicitar Devolução". Siga as instruções fornecidas.',
    },
    {
      'question': 'Quais são as formas de pagamento aceitas?',
      'answer':
          'Aceitamos cartão de crédito, débito, PayPal e outros métodos de pagamento digital. Todos são processados com segurança.',
    },
    {
      'question': 'Meu pedido foi cancelado, quando recebo o reembolso?',
      'answer':
          'Reembolsos são processados em até 5 dias úteis após o cancelamento. Você receberá uma confirmação por email.',
    },
    {
      'question': 'Como posso atualizar meus dados de perfil?',
      'answer':
          'Acesse "Configurações" no menu da sua conta para editar seu nome e foto de perfil. Email não pode ser alterado.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajuda e Suporte',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(24),
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perguntas Frequentes',
                    style: AppTextStyle.h2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Encontre respostas para as dúvidas mais comuns',
                    style: AppTextStyle.withColor(
                      AppTextStyle.bodyMedium,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                ],
              ),
            ),
            // FAQs List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                return _buildFaqItem(
                  context,
                  question: faqs[index]['question']!,
                  answer: faqs[index]['answer']!,
                );
              },
            ),
            // Contact Section
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Não encontrou sua resposta?',
                    style: AppTextStyle.h3,
                  ),
                  const SizedBox(height: 16),
                  _buildContactOption(
                    context,
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: 'suporte@loja.com',
                  ),
                  const SizedBox(height: 12),
                  _buildContactOption(
                    context,
                    icon: Icons.phone_outlined,
                    title: 'Telefone',
                    value: '(11) 1234-5678',
                  ),
                  const SizedBox(height: 12),
                  _buildContactOption(
                    context,
                    icon: Icons.schedule_outlined,
                    title: 'Horário de Atendimento',
                    value: 'Segunda a Sexta, 09:00 - 18:00',
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Funcionalidade em desenvolvimento'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Enviar Mensagem',
                        style: AppTextStyle.withColor(
                          AppTextStyle.buttonMedium,
                          Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Additional Help Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade600,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Dica de Segurança',
                          style: AppTextStyle.withColor(
                            AppTextStyle.bodyMedium,
                            Colors.blue.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nunca compartilhe sua senha com ninguém. Nossa equipe de suporte nunca pedirá sua senha ou dados bancários.',
                    style: AppTextStyle.withColor(
                      AppTextStyle.bodySmall,
                      isDark ? Colors.grey[300]! : Colors.grey[700]!,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTextStyle.bodyMedium,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              answer,
              style: AppTextStyle.withColor(
                AppTextStyle.bodySmall,
                isDark ? Colors.grey[400]! : Colors.grey[600]!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyle.withColor(
                AppTextStyle.bodySmall,
                isDark ? Colors.grey[400]! : Colors.grey[600]!,
              ),
            ),
            Text(
              value,
              style: AppTextStyle.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}

