import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ CLEAR old data on first run (COMMENT THIS OUT LATER if you want persistence)
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('student_data'); // Clear old login
  
  runApp(MyCampusApp());
}

class MyCampusApp extends StatefulWidget {
  @override
  State<MyCampusApp> createState() => _MyCampusAppState();
}

class _MyCampusAppState extends State<MyCampusApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _onThemeChanged(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyCampus',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F65B0),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F65B0),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F23),
      ),
      home: FutureBuilder<String>(
        future: _getStudentData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return LoginScreen(onLoginSuccess: _onThemeChanged);
          }

          final data = snapshot.data!.split('|');
          if (data.length < 3) {
            return LoginScreen(onLoginSuccess: _onThemeChanged);
          }

          return HomeScreen(
            studentName: data[0],
            college: data[1],
            uid: data[2],
            onThemeChanged: _onThemeChanged,
          );
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<String> _getStudentData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('student_data') ?? '';
  }
}

class LoginScreen extends StatefulWidget {
  final Function(ThemeMode) onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();
  String? _selectedCollege;
  bool _isLoading = false;

  final List<String> colleges = [
    'Chandigarh University',
    'Panjab University',
    'DAV College',
    'St. Stephen\'s College',
    'Government College for Girls',
  ];

  Future<void> _login() async {
    if (_nameController.text.isEmpty ||
        _selectedCollege == null ||
        _uidController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final studentData =
          '${_nameController.text}|${_selectedCollege}|${_uidController.text}';
      await prefs.setString('student_data', studentData);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              studentName: _nameController.text,
              college: _selectedCollege!,
              uid: _uidController.text,
              onThemeChanged: widget.onLoginSuccess,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1F65B0), Color(0xFF2B7FC7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school_rounded,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                'MyCampus',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Campus Companion',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 60),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Student Name
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your name',
                        prefixIcon: const Icon(Icons.person_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // College Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCollege,
                      decoration: InputDecoration(
                        labelText: 'College',
                        hintText: 'Select your college',
                        prefixIcon: const Icon(Icons.school_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: colleges.map((college) {
                        return DropdownMenuItem(
                          value: college,
                          child: Text(college),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCollege = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // UID
                    TextField(
                      controller: _uidController,
                      decoration: InputDecoration(
                        labelText: 'Student UID',
                        hintText: 'e.g., CU2023001',
                        prefixIcon: const Icon(Icons.badge_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F65B0),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _uidController.dispose();
    super.dispose();
  }
}
