import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://ancrolyn.web.app/ferramentas'); // Substitua pelo link desejado
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // Força a abertura no navegador padrão
    )) {
      // Se não conseguir abrir, pode mostrar um erro (opcional)
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Apeiron")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Apeiron", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Version: 1.0.0"),
            const SizedBox(height: 20),
            const Text("Apeiron is a Wallpaper SlideShow engine that allows you to automatically switch your favorite photos as your Android background."),
            const SizedBox(height: 20),
            InkWell(
              onTap: _launchURL, // Chama a função ao clicar
              child: const Text(
                "Click here and discover more tools on Ancrolyn",
                style: TextStyle(
                  color: Colors.blueAccent, // Usa a cor primária do tema
                  decoration: TextDecoration.underline, // Adiciona um sublinhado
                  decorationColor: Colors.blueAccent,
                ),
              ),
            ),
            const Spacer(),
            const Center(child: Text("Developed by wesleymelodev", style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}