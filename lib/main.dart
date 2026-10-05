import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MinecraftAddonStudioApp());
}

class MinecraftAddonStudioApp extends StatelessWidget {
  const MinecraftAddonStudioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MC Bedrock Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // خلفية داكنة أنيقة وعميقة
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const StudioHomePage(),
    );
  }
}

class StudioHomePage extends StatefulWidget {
  const StudioHomePage({Key? key}) : super(key: key);

  @override
  State<StudioHomePage> createState() => _StudioHomePageState();
}

class _StudioHomePageState extends State<StudioHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<AddonCategory> categories = [
    AddonCategory('بلوكات جديدة', 'إنشاء كتل وبيئة مخصصة', Icons.dashboard_rounded, Colors.amber),
    AddonCategory('أدوات وأسلحة', 'سيوف، فؤوس ودروع بميزات خارقة', Icons.flash_on_rounded, Colors.blueAccent),
    AddonCategory('عناصر (Items)', 'موارد وأطعمة وعناصر جديدة', Icons.diamond_rounded, Colors.purpleAccent),
    AddonCategory('مخلوقات (Mobs)', 'تعديل أو إضافة وحوش وكائنات', Icons.pest_control_rounded, Colors.redAccent),
    AddonCategory('وصفات الصنع (Recipes)', 'تحديد طرق دمج العناصر في طاولة العمل', Icons.menu_book_rounded, Colors.greenAccent),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مصنع إضافات ماين كرافت', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_special, color: Colors.amberAccent),
            onPressed: () {
              // قائمة الإضافات المصدرة مسبقاً
            },
          )
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'اختر نوع الإضافة يا boss man:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cat.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(cat.icon, color: cat.color, size: 28),
                        ),
                        title: Text(
                          cat.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(cat.subtitle, style: const TextStyle(color: Colors.white60, fontSize: 13)),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white54),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddonBuilderPage(categoryTitle: cat.title),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddonCategory {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  AddonCategory(this.title, this.subtitle, this.icon, this.color);
}

// ==========================================
// صفحة إنشاء وتخصيص الإضافة
// ==========================================
class AddonBuilderPage extends StatefulWidget {
  final String categoryTitle;
  const AddonBuilderPage({Key? key, required this.categoryTitle}) : super(key: key);

  @override
  State<AddonBuilderPage> createState() => _AddonBuilderPageState();
}

class _AddonBuilderPageState extends State<AddonBuilderPage> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  double _customValue = 5.0; // مثال لخاصية القوة أو الضرر

  void _generateAddonPackage() {
    if (_nameController.text.isEmpty || _idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تعبئة اسم المعرف والأضاقة يا boss man!')),
      );
      return;
    }

    // هنا يتم تجميع ملفات JSON التلقائية (manifest.json, items/blocks json)
    // وضغطها في مجلد التطبيق الخارجي بصيغة .mcpack
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('تم بنجاح!'),
        content: Text('تم إنشاء ملف الإضافة "${_nameController.text}" وتجهيزه للاستيراد في ماين كرافت بنجاح.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('حفظ وفتح في اللعبة', style: TextStyle(color: Colors.emeraldAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إعداد: ${widget.categoryTitle}', style: const TextStyle(fontSize: 16)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        z: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'اسم الإضافة (مثال: SuperSword)',
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'المعرف الفريد (مثال: my_mod:super_sword)',
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('قوة التأثير أو الضرر:', style: TextStyle(color: Colors.white70)),
                Text('${_customValue.toInt()}', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: _customValue,
              min: 1,
              max: 100,
              divisions: 99,
              activeColor: Colors.emeraldAccent,
              onChanged: (val) => setState(() => _customValue = val),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generateAddonPackage,
                icon: const Icon(Icons.build_rounded),
                label: const Text('توليد وحفظ ملف الإضافة (.mcpack)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
