// =============== ИМПОРТЫ ===============
import 'dart:async';
// ignore: unused_import
import 'dart:typed_data';
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:mailer/mailer.dart';
// ignore: unused_import
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
// ignore: unused_import
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:share_handler/share_handler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
// ignore: unused_import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:camerawesome/camerawesome_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 1));
  runApp(const MarkotkhGuideApp());
}

// =============== ГЛАВНОЕ ПРИЛОЖЕНИЕ ===============
class MarkotkhGuideApp extends StatefulWidget {
  const MarkotkhGuideApp({super.key});
  @override
  _MarkotkhGuideAppState createState() => _MarkotkhGuideAppState();
}

class _MarkotkhGuideAppState extends State<MarkotkhGuideApp> {
  ThemeMode _themeMode = ThemeMode.light;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
      if (!isFirstLaunch) return;
      await Future.delayed(const Duration(milliseconds: 300));
      final navContext = _navigatorKey.currentContext;
      if (navContext != null) {
        showDialog(
          context: navContext,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 24,
            title: Center(
              child: Text(
                "👋 Добро пожаловать в «Маркотх Гид»",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFamily: 'ComicSans',
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Приложение «Маркотх Гид» — создано для определения животных и растений по фотографии и видео.\n",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      fontFamily: 'ComicSans',
                    ),
                  ),
                  Center(
                    child: Text(
                      "📌 Как это работает:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontFamily: 'ComicSans',
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "1️⃣ Сделайте фото/видео или выберите из галереи.\n"
"2️⃣ Искусственный интеллект определит вид животного или растения.\n"
"3️⃣ Вы получите подробную информацию о найденном виде.\n"
"4️⃣ История анализов сохраняется для вашего удобства.\n"
"📖 Подробная инструкция по использованию приложения доступна в разделе «Настройки» -> «Подробная справка по приложению».\n"
"✨ Открывайте для себя удивительный мир природы с помощью современных технологий!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      fontFamily: 'ComicSans',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.4),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isFirstLaunch', false);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text("Начать", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'ComicSans')),
                  ),
                ),
              ),
            ],
          ).animate(
            effects: [
              ScaleEffect(duration: 400.ms, curve: Curves.elasticOut),
              FadeEffect(duration: 500.ms),
            ],
          ),
        );
      }
    } catch (e) {
      // Просто игнорируем ошибку, приветствие не покажется
    }
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkTheme') ?? false;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDark);
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    _saveTheme(isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru'),
          Locale('en'),
        ],
        locale: const Locale('ru'),
        title: 'Маркотх Гид',
        scaffoldMessengerKey: _scaffoldMessengerKey,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'ComicSans',
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
            primary: Colors.green,
            secondary: Colors.greenAccent,
          ),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.green.shade800,
              fontFamily: 'ComicSans',
            ),
            iconTheme: IconThemeData(color: Colors.green.shade800),
          ),
          cardTheme: CardThemeData(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.all(8),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.green.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.green.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.green.shade500, width: 2),
            ),
            filled: true,
            fillColor: Colors.green.shade50,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          fontFamily: 'ComicSans',
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
            primary: Colors.green,
            secondary: Colors.greenAccent,
          ),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            backgroundColor: Color(0xFF0A2A0A),
            elevation: 0,
            titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.green.shade200,
              fontFamily: 'ComicSans',
            ),
            iconTheme: IconThemeData(color: Colors.green.shade200),
          ),
          cardTheme: CardThemeData(
            elevation: 12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.all(8),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            elevation: 12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.green.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.green.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.green.shade300, width: 2),
            ),
            filled: true,
            fillColor: Colors.green.shade900.withOpacity(0.3),
          ),
        ),
        themeMode: _themeMode,
        home: MarkotkhGuideScreen(
          onThemeToggle: _toggleTheme,
          scaffoldMessengerKey: _scaffoldMessengerKey,
        ),
      ),
    );
  }
}

// =============== ОСНОВНОЙ ЭКРАН ===============
class MarkotkhGuideScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  const MarkotkhGuideScreen({super.key, required this.onThemeToggle, required this.scaffoldMessengerKey});
  @override
  State<MarkotkhGuideScreen> createState() => _MarkotkhGuideScreenState();
}

class _MarkotkhGuideScreenState extends State<MarkotkhGuideScreen> with TickerProviderStateMixin {
  File? _selectedImage;
  File? _selectedVideo;
  String _result = '';
  bool showRetryButton = false;
  bool _showInspirationalText = true;
  bool _isLoading = false;
  String? _species;
  // ignore: unused_field
  bool _isCameraSource = false;
  bool _isVideo = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, dynamic>> _animalHistory = [];
  final List<Map<String, dynamic>> _plantHistory = [];
  bool _saveCameraPhotos = false;
  late AnimationController _imageScaleController;
  late Animation<double> _imageScaleAnimation;
  bool _hasSelectedMedia = false;
  VideoPlayerController? _videoPlayerController;
  // ignore: unused_field
  bool _isRecording = false;
  Timer? _recordingTimer;
  // ignore: unused_field
  int _recordingDuration = 0;
  final int _maxVideoDuration = 60; // Максимальная длительность видео в секундах

  Future<void> _handleSharedImage(String path) async {
    try {
      setState(() {
        _isLoading = true;
        _result = '⏳ Анализ изображения...';
      });

      await _analyzeMedia(File(path), false);

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _result = '⚠️ Ошибка при обработке изображения';
      });
    }
  }

  @override
void initState() {
  super.initState();
  if (!kIsWeb) {
    final handler = ShareHandler.instance;
    handler.getInitialSharedMedia().then((SharedMedia? media) {
      if (media != null && media.attachments != null && media.attachments!.isNotEmpty) {
        _handleSharedImage(media.attachments!.first!.path);
      }
    });
    handler.sharedMediaStream.listen((SharedMedia media) {
      if (media.attachments != null && media.attachments!.isNotEmpty) {
        _handleSharedImage(media.attachments!.first!.path);
      }
    });
  }
  _loadAnimalHistory();
  _loadPlantHistory();
  _loadSaveCameraPhotos();
  _imageScaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  _imageScaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
    CurvedAnimation(parent: _imageScaleController, curve: Curves.easeInOut),
  );
  _imageScaleController.repeat(reverse: true);

  // Добавляем проверку восстановления видео
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await Future.delayed(Duration(seconds: 1));
    await _checkAndRestoreVideo();
  });
  
  // Инициализируем видео контроллер только если выбранное видео существует
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (_selectedVideo != null && await _selectedVideo!.exists()) {
      await _initializeVideoController(_selectedVideo!);
    }
  });
}

Future<void> _checkAndRestoreVideo() async {
  // Проверяем, есть ли выбранное видео
  if (_selectedVideo != null && _isVideo) {
    print('🔍 Проверяем восстановление видео после перезапуска...');
    
    try {
      final fileExists = await _selectedVideo!.exists();
      print('📁 Видео файл существует: $fileExists (${_selectedVideo!.path})');
      
      if (fileExists) {
        final initialized = await _initializeVideoController(_selectedVideo!);
        print('🎬 Видео контроллер восстановлен: $initialized');
        
        if (initialized && mounted) {
          setState(() {
            _hasSelectedMedia = true;
            _imageScaleController.stop();
          });
        }
      } else {
        print('❌ Видео файл не найден, очищаем анализ');
        _resetAnalysis();
      }
    } catch (e) {
      print('❌ Ошибка восстановления видео: $e');
      _resetAnalysis();
    }
  }
}

  @override
void dispose() {
  _imageScaleController.dispose();
  _videoPlayerController?.dispose();
  _videoPlayerController = null;
  _recordingTimer?.cancel();
  VideoCompress.dispose();
  super.dispose();
}

  void _resetAnalysis() {
  if (_videoPlayerController != null) {
    _videoPlayerController!.pause();
    _videoPlayerController!.dispose();
    _videoPlayerController = null;
  }
  
  setState(() {
    _selectedImage = null;
    _selectedVideo = null;
    _result = '';
    _hasSelectedMedia = false;
    _showInspirationalText = true;
    _isVideo = false;
    _imageScaleController.repeat(reverse: true);
  });
}

Future<void> _safePauseVideo() async {
  if (_videoPlayerController != null && 
      _videoPlayerController!.value.isInitialized &&
      _videoPlayerController!.value.isPlaying) {
    await _videoPlayerController!.pause();
    if (mounted) setState(() {});
  }
}

Future<void> _safePlayVideo() async {
  if (_videoPlayerController != null && 
      _videoPlayerController!.value.isInitialized &&
      !_videoPlayerController!.value.isPlaying) {
    await _videoPlayerController!.play();
    if (mounted) setState(() {});
  }
}

  // === ЗАГРУЗКА/СОХРАНЕНИЕ НАСТРОЕК ===
  Future<void> _loadSaveCameraPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _saveCameraPhotos = prefs.getBool('saveCameraPhotos') ?? false;
    });
  }

  Future<void> _saveCameraPhotosSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('saveCameraPhotos', value);
    setState(() {
      _saveCameraPhotos = value;
    });
  }

  Future<void> _loadAnimalHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final historyJson = prefs.getString('animalHistory');
  if (historyJson != null) {
    try {
      final List<dynamic> historyList = jsonDecode(historyJson);
      setState(() {
        _animalHistory.clear();
        _animalHistory.addAll(historyList.map((item) {
          final imagePath = item['imagePath'];
          bool fileExists = false;
          if (imagePath != null && imagePath is String) {
            try {
              final file = File(imagePath);
              fileExists = file.existsSync();
              print('📁 Проверка файла $imagePath: $fileExists');
            } catch (e) {
              print('❌ Ошибка проверки файла: $e');
              fileExists = false;
            }
          }
          
          DateTime date;
          try {
            if (item['date'] is String) {
              date = DateTime.parse(item['date']);
            } else {
              date = DateTime.now();
            }
          } catch (e) {
            print('❌ Ошибка парсинга даты: $e');
            date = DateTime.now();
          }
          
          // Определяем, является ли файл видео
          bool isVideoItem = false;
          if (imagePath != null && imagePath is String) {
            final lowerPath = imagePath.toLowerCase();
            isVideoItem = lowerPath.endsWith('.mp4') || 
                         lowerPath.endsWith('.mov') || 
                         lowerPath.endsWith('.avi') ||
                         lowerPath.endsWith('.mkv') ||
                         lowerPath.endsWith('.webm');
            
            // Также проверяем поле isVideo
            if (item['isVideo'] != null) {
              isVideoItem = item['isVideo'] ?? isVideoItem;
            }
          }
          
          print('📊 Загрузка записи: ${item['species']}, видео: $isVideoItem, файл: $fileExists');
          
          return {
            'date': date,
            'species': item['species'] ?? 'Неизвестный вид',
            'type': item['type'] ?? 'Животное',
            'result': item['result'] ?? '',
            'imagePath': fileExists ? imagePath : null,
            'isVideo': isVideoItem,
          };
        }).toList());
      });
    } catch (e) {
      print('❌ Ошибка загрузки истории животных: $e');
    }
  } else {
    print('📭 История животных пуста');
  }
}

  Future<void> _loadPlantHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final historyJson = prefs.getString('plantHistory');
  if (historyJson != null) {
    try {
      final List<dynamic> historyList = jsonDecode(historyJson);
      setState(() {
        _plantHistory.clear();
        _plantHistory.addAll(historyList.map((item) {
          final imagePath = item['imagePath'];
          bool fileExists = false;
          if (imagePath != null && imagePath is String) {
            try {
              final file = File(imagePath);
              fileExists = file.existsSync();
              print('📁 Проверка файла растений $imagePath: $fileExists');
            } catch (e) {
              print('❌ Ошибка проверки файла растений: $e');
              fileExists = false;
            }
          }
          
          DateTime date;
          try {
            if (item['date'] is String) {
              date = DateTime.parse(item['date']);
            } else {
              date = DateTime.now();
            }
          } catch (e) {
            print('❌ Ошибка парсинга даты растений: $e');
            date = DateTime.now();
          }
          
          // Определяем, является ли файл видео
          bool isVideoItem = false;
          if (imagePath != null && imagePath is String) {
            final lowerPath = imagePath.toLowerCase();
            isVideoItem = lowerPath.endsWith('.mp4') || 
                         lowerPath.endsWith('.mov') || 
                         lowerPath.endsWith('.avi') ||
                         lowerPath.endsWith('.mkv') ||
                         lowerPath.endsWith('.webm');
            
            // Также проверяем поле isVideo
            if (item['isVideo'] != null) {
              isVideoItem = item['isVideo'] ?? isVideoItem;
            }
          }
          
          print('📊 Загрузка записи растений: ${item['species']}, видео: $isVideoItem, файл: $fileExists');
          
          return {
            'date': date,
            'species': item['species'] ?? 'Неизвестный вид',
            'type': item['type'] ?? 'Растение',
            'result': item['result'] ?? '',
            'imagePath': fileExists ? imagePath : null,
            'isVideo': isVideoItem,
          };
        }).toList());
      });
    } catch (e) {
      print('❌ Ошибка загрузки истории растений: $e');
    }
  } else {
    print('📭 История растений пуста');
  }
}

  Future<void> _saveAnimalHistory() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    // Проверяем каждый файл перед сохранением
    final List<Map<String, dynamic>> validHistory = [];
    
    for (final item in _animalHistory) {
      final imagePath = item['imagePath'];
      bool fileExists = false;
      
      if (imagePath != null && imagePath is String) {
        try {
          final file = File(imagePath);
          fileExists = await file.exists();
          print('💾 Проверка перед сохранением: $imagePath - $fileExists');
        } catch (e) {
          print('❌ Ошибка проверки файла перед сохранением: $e');
        }
      }
      
      validHistory.add({
        'date': item['date'] is DateTime 
            ? (item['date'] as DateTime).toIso8601String() 
            : DateTime.now().toIso8601String(),
        'species': item['species'] ?? 'Неизвестный вид',
        'type': item['type'] ?? 'Животное',
        'result': item['result'] ?? '',
        'imagePath': fileExists ? imagePath : null,
        'isVideo': item['isVideo'] ?? false,
      });
    }
    
    final historyJson = jsonEncode(validHistory);
    await prefs.setString('animalHistory', historyJson);
    print('✅ История животных сохранена: ${validHistory.length} записей');
    
  } catch (e) {
    print('❌ Ошибка сохранения истории животных: $e');
  }
}

  Future<void> _savePlantHistory() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    // Проверяем каждый файл перед сохранением
    final List<Map<String, dynamic>> validHistory = [];
    
    for (final item in _plantHistory) {
      final imagePath = item['imagePath'];
      bool fileExists = false;
      
      if (imagePath != null && imagePath is String) {
        try {
          final file = File(imagePath);
          fileExists = await file.exists();
          print('💾 Проверка растений перед сохранением: $imagePath - $fileExists');
        } catch (e) {
          print('❌ Ошибка проверки файла растений: $e');
        }
      }
      
      validHistory.add({
        'date': item['date'] is DateTime 
            ? (item['date'] as DateTime).toIso8601String() 
            : DateTime.now().toIso8601String(),
        'species': item['species'] ?? 'Неизвестный вид',
        'type': item['type'] ?? 'Растение',
        'result': item['result'] ?? '',
        'imagePath': fileExists ? imagePath : null,
        'isVideo': item['isVideo'] ?? false,
      });
    }
    
    final historyJson = jsonEncode(validHistory);
    await prefs.setString('plantHistory', historyJson);
    print('✅ История растений сохранена: ${validHistory.length} записей');
    
  } catch (e) {
    print('❌ Ошибка сохранения истории растений: $e');
  }
}

  Future<String?> _saveImagePermanently(File image) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'nature_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newPath = '${directory.path}/$fileName';
      
      final imageBytes = await image.readAsBytes();
      final newFile = File(newPath);
      await newFile.writeAsBytes(imageBytes);
      
      if (await newFile.exists()) {
        final fileSize = await newFile.length();
        print('💾 Изображение сохранено: $newPath (${fileSize} bytes)');
        return newPath;
      } else {
        print('❌ Ошибка: файл не создан');
        return null;
      }
    } catch (e) {
      print('❌ Ошибка сохранения изображения: $e');
      return null;
    }
  }

  Future<String?> _saveVideoPermanently(File video) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    
    // Создаем отдельную папку для видео, если её нет
    final videosDir = Directory('${directory.path}/videos');
    if (!await videosDir.exists()) {
      await videosDir.create(recursive: true);
    }
    
    final fileName = 'nature_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final newPath = '${videosDir.path}/$fileName';
    
    print('💾 Сохранение видео: ${video.path} -> $newPath');
    
    // Копируем файл
    await video.copy(newPath);
    
    final newFile = File(newPath);
    if (await newFile.exists()) {
      final fileSize = await newFile.length();
      final sizeMB = fileSize / 1024 / 1024;
      print('✅ Видео сохранено: $newPath (${sizeMB.toStringAsFixed(2)} MB)');
      return newPath;
    } else {
      print('❌ Ошибка: видео файл не создан');
      return null;
    }
  } catch (e, stackTrace) {
    print('❌ Ошибка сохранения видео: $e');
    print('Stack trace: $stackTrace');
    return null;
  }
}

  String _formatHistoryDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    
    return '$day-$month-$year\n$hour:$minute';
  }

  // === ИНТЕРНЕТ И СЖАТИЕ ===
  Future<bool> _checkInternet() async {
    final endpoints = ['https://1.1.1.1', 'https://8.8.8.8', 'https://api.github.com'];
    for (int attempt = 0; attempt < 2; attempt++) {
      for (final endpoint in endpoints) {
        try {
          final response = await http.get(Uri.parse(endpoint)).timeout(const Duration(seconds: 2));
          if (response.statusCode >= 200 && response.statusCode < 300) return true;
        } catch (_) {}
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
    return false;
  }

  Future<File?> _compressImage(File image) async {
    try {
      final fileSize = await image.length();
      if (fileSize < 500000) return image;
      final tempDir = Directory.systemTemp;
      final targetPath = '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path, targetPath, quality: 60, minWidth: 600, minHeight: 600, format: CompressFormat.jpeg,
      );
      if (compressedFile == null) return null;
      final compressedSize = await compressedFile.length();
      if (compressedSize > 4_000_000) return null;
      return File(compressedFile.path);
    } catch (e) {
      return null;
    }
  }

  Future<File?> _compressVideo(File video) async {
  try {
    print('🎬 Начинаю оптимизацию видео для анализа: ${video.path}');
    
    // Проверяем существование файла
    if (!await video.exists()) {
      print('❌ Видеофайл не существует');
      return null;
    }
    
    // Получаем информацию о видео
    final info = await VideoCompress.getMediaInfo(video.path);
    final filesize = info.filesize ?? 0;
    final durationSeconds = (info.duration ?? 0) / 1000;
    final width = info.width ?? 0;
    final height = info.height ?? 0;
    
    print('📊 Информация о видео:');
    print('   Размер: ${(filesize / 1024 / 1024).toStringAsFixed(2)} MB');
    print('   Длительность: ${durationSeconds.toStringAsFixed(2)} сек');
    print('   Разрешение: ${width}x${height}');
    
    // Определяем стратегию сжатия на основе характеристик видео
    final strategy = _determineCompressionStrategy(
      filesize: filesize,
      duration: durationSeconds,
      resolution: width * height,
    );
    
    print('⚙️ Стратегия оптимизации:');
    print('   Качество: ${strategy.quality.name}');
    print('   FPS: ${strategy.frameRate}');
    print('   Аудио: ${strategy.includeAudio ? "Вкл" : "Выкл"}');
    print('   Длительность: ${strategy.targetDuration.toStringAsFixed(1)} сек');
    
    // Если видео уже оптимального размера, возвращаем как есть
    if (filesize < strategy.maxSizeBeforeCompression) {
      print('✅ Видео уже оптимального размера (${(filesize / 1024 / 1024).toStringAsFixed(2)} MB)');
      return video;
    }
    
    // Если видео слишком короткое
    if (durationSeconds < 1.0) {
      print('⚠️ Видео слишком короткое (${durationSeconds.toStringAsFixed(2)} сек)');
      // Для очень коротких видео увеличиваем качество
      return await _compressWithHighQuality(video);
    }
    
    // Основная оптимизация с интеллектуальными параметрами
    final compressed = await VideoCompress.compressVideo(
      video.path,
      quality: strategy.quality,
      deleteOrigin: false,
      includeAudio: strategy.includeAudio,
      frameRate: strategy.frameRate,
      startTime: 0,
      duration: (strategy.targetDuration * 1000).toInt(),
    );
    
    if (compressed == null || compressed.file == null) {
      print('⚠️ Основное сжатие не удалось, пробую альтернативные параметры');
      return await _tryAlternativeCompression(video, strategy);
    }
    
    final compressedFile = compressed.file!;
    final compressedSize = await compressedFile.length();
    final sizeMB = compressedSize / 1024 / 1024;
    
    print('📉 После оптимизации: ${sizeMB.toStringAsFixed(2)} MB');
    
    // Проверяем качество сжатия
    if (sizeMB > strategy.maxTargetSize) {
      print('🔄 Результат все еще большой, применяю дополнительную оптимизацию');
      return await _applyAdditionalOptimization(compressedFile, strategy);
    }
    
    // Проверяем минимальный размер (слишком маленький файл может быть плохого качества)
    if (sizeMB < 0.5 && durationSeconds > 3) {
      print('⚠️ Видео слишком маленькое после сжатия, возможно низкое качество');
      return await _compressWithBetterQuality(video);
    }
    
    print('✅ Оптимизация успешно завершена');
    return compressedFile;
    
  } catch (e, stackTrace) {
    print('❌ Ошибка оптимизации видео: $e');
    print('Stack trace: $stackTrace');
    
    // В случае ошибки пытаемся вернуть оригинал, если он не слишком большой
    return await _fallbackToOriginal(video);
  }
}

  // === ОБЪЕДИНЕННЫЙ АНАЛИЗ МЕДИА ===
  Future<String> _analyzeMedia(File file, bool isVideo) async {
    // Проверяем, существует ли файл
  if (!await file.exists()) {
    return '⚠️ Ошибка: Файл не найден';
  }
  
  // Проверяем размер файла
  final fileSize = await file.length();
  if (fileSize == 0) {
    return '⚠️ Ошибка: Файл пустой';
  }
    final serverUrl = isVideo 
      ? 'https://gemini-proxy-nine-alpha.vercel.app/analyze-video'
      : 'https://gemini-proxy-nine-alpha.vercel.app/generate';
    
    final prompt = isVideo ? '''
Ты — эксперт по биологии с навыками компьютерного зрения и распознавания животных и растений. Твоя задача — максимально точно определить вид животного или растения на видео. Анализируй ВСЕ кадры видео и выдай обобщенный результат.

КРИТИЧЕСКИ ВАЖНО:
- Проанализируй ВСЁ видео целиком, не пропускай кадры
- Если на видео несколько организмов — выбери главного (крупнейшего, наиболее четкого)
- Игнорируй искусственные объекты, только ЖИВЫЕ существа
- Отвечай только при уверенности ≥95%

Следуй строгой инструкции:
1! Если это РЕАЛЬНОЕ животное или растение, ответь строго по пунктам:
1. Вид: [название на русском и на английском языке]
2. Тип: [Животное/Растение]
3. Описание: [3–5 коротких фактов о виде, среде обитания, особенностях и другой информации из интернета] + используй тут маркерные точки[•], чтобы ответ выглядел хорошо и красиво
4. Статус: укажи, включён ли вид в Красную книгу России или международные списки охраны природы, выбрав одну из формулировок — «Не занесён в Красную книгу» (поясни, что вид распространён и не является редким), «Редкий вид» (уточни, где имеет охранный статус, например в региональной Красной книге), «Находится под угрозой исчезновения» (уточни, в какой именно Красной книге и какие меры применяются) или «Охраняется международными соглашениями» (кратко объясни значение договора для широкой аудитории), обязательно сохранив прямое упоминание Красной книги в ответе - то есть слова 'Красная книга' должны упоминаться хотя бы 1 раз!.
5. Состояние: оцени визуальное состояние организма по видео, всё ли хорошо или нет. [оценка здоровья при необходимости]
6. Поведение: [опиши поведение, движения, активность организма на видео, напиши что оно делает, понятными словами для пользователя]

❗ Безопасность: 
[Если вид ЯДОВИТ/ОПАСЕН — выдели это ОСОБО:
• Уровень опасности: [высокий/средний/низкий]
• Опасные части: [корни, листья, плоды и т.д.]
• Симптомы отравления: [кратко]
• Первая помощь: [рекомендации]
Если вид ОПАСЕН — укажи это в отдельном пункте ответа + используй эмодзи: ❗]

7. Рекомендации: [Если состояние плохое - дай базовые рекомендации по уходу/помощи. Что нужно сделать? Если отличное - напиши "Растение/животное не требуются в рекомендациях"]

2! Если это НЕ животное и НЕ растение, напиши используя тут маркерные точки[•]:
- Что изображено: [описание]
- Сообщение: На видео нет животных или растений. Анализ невозможен. Пожалуйста, загрузите видео природы.

Запрещено:
- Определять несколько организмов в одном ответе
- Описывать искусственные объекты как живые
- Использовать слова "наверное", "возможно", "скорее всего"

ВСЕГДА следуй этому формату и не добавляй лишних пояснений.
''' : '''
Ты — эксперт по биологии с навыками компьютерного зрения и распознавания животных и растений. Твоя задача — максимально точно определить вид животного или растения на изображении. Дополнительно, для уверенности ты должен искать информацию в интернете, сравнивать картинки, чтобы дать максимально верную и точную информацию!

Отвечай только при уверенности, исключая слова "наверное", "возможно", "скорее всего" и других подобных слов. 

КРИТИЧЕСКИ ВАЖНО:
- Анализируй только ОДИН основной организм на фото (животное или растение)
- Если на фото несколько организмов — выбери самого крупного и четкого
- Игнорируй искусственные объекты, рисунки, экраны, чучела и другие, только ЖИВЫЕ существа
- Отвечай только при уверенности ≥95%

Следуй строгой инструкции:
1! Если это РЕАЛЬНОЕ животное или растение, ответь строго по пунктам:
1. Вид: [название на русском и на английском языке]
2. Тип: [Животное/Растение]
3. Описание: [3–5 коротких фактов о виде, среде обитания, особенностях и другой информации из интернета] + используй тут маркерные точки[•], чтобы ответ выглядел хорошо и красиво
4. Статус: укажи, включён ли вид в Красную книгу России или международные списки охраны природы, выбрав одну из формулировок — «Не занесён в Красную книгу» (поясни, что вид распространён и не является редким), «Редкий вид» (уточни, где имеет охранный статус, например в региональной Красной книге), «Находится под угрозой исчезновения» (уточни, в какой именно Красной книге и какие меры применяются) или «Охраняется международными соглашениями» (кратко объясни значение договора для широкой аудитории), обязательно сохранив прямое упоминание Красной книги в ответе - то есть слова 'Красная книга' должны упоминаться хотя бы 1 раз!.
5. Состояние: оцени визуальное состояние организма по фото, всё ли хорошо или нет. [оценка здоровья при необходимости]

❗ Безопасность: 
[Если вид ЯДОВИТ/ОПАСЕН — выдели это ОСОБО:
• Уровень опасности: [высокий/средний/низкий]
• Опасные части: [корни, листья, плоды и т.д.]
• Симптомы отравления: [кратко]
• Первая помощь: [рекомендации]
Если вид ОПАСЕН — укажи это в отдельном пункте ответа + используй эмодзи: ❗]

6. Рекомендации: [Если состояние плохое - дай базовые рекомендации по уходу/помощи. Что нужно сделать? Если отличное - напиши "Растение/животное не требуются в рекомендациях либо как-то по-другому"]
7. Если изображение НЕ было сделано в реальных условиях (например, это снимок экрана, фотографии с бумаги, монитора и т.п.), и также если оно было сделано в реальной жизни укажи это. Обязательно укажи это в новой строке, начинающейся с:
🌐 Источник: [укажи откуда]

2! Если это НЕ животное и НЕ растение, напиши используя тут маркерные точки[•]:
- Что изображено: [описание]
- Сообщение: На изображении нет животных или растений. Анализ невозможен. Пожалуйста, загрузите фото природы.

Запрещено:
- Определять несколько организмов в одном ответе
- Описывать искусственные объекты как живые
- Повторять одинаковую информацию в "Состоянии" и "Рекомендациях"
- Использовать слова "наверное", "возможно", "скорее всего"

ВСЕГДА следуй этому формату и не добавляй лишних пояснений.
''';

    try {
      // Сжатие медиа
      final compressedMedia = isVideo ? await _compressVideo(file) : await _compressImage(file);
      if (compressedMedia == null) {
        return '⚠️ Ошибка: Не удалось сжать ${isVideo ? 'видео' : 'изображение'}.';
      }

      // Чтение байтов
      final mediaBytes = await compressedMedia.readAsBytes();
      
      if (isVideo) {
        // Для видео проверяем размер в байтах (не base64!)
        final double mb = mediaBytes.length / 1024 / 1024;
        print('📦 Итоговый размер видео: ${mb.toStringAsFixed(2)} MB');

        if (mb > 6.0) {
          return '''⚠️ Ошибка: Размер видео превышает 6 МБ даже после сжатия.

Для обхода ограничений необходимо:
1. Снимайте видео до 10 секунд
2. Убедитесь в хорошем освещении
3. Подойдите ближе к объекту
4. Лучше используйте фото''';
        }
      } else {
        // Для изображения проверяем base64 размер
        final base64Image = base64Encode(mediaBytes);
        if (base64Image.length > 4_000_000) {
          return '⚠️ Ошибка: Размер изображения превышает 4 МБ.';
        }
      }

      // Конвертация в base64
      final base64Media = base64Encode(mediaBytes);

      // Отправка на сервер
      final response = await http
          .post(
            Uri.parse(serverUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'prompt': prompt,
              'image_base64': isVideo ? null : base64Media,
              'video_base64': isVideo ? base64Media : null,
              'mime_type': isVideo ? 'video/mp4' : 'image/jpeg',
            }),
          )
          .timeout(Duration(seconds: isVideo ? 90 : 30));

      // Обработка ответа
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final result = jsonResponse['response'] ?? 'Не удалось получить результат.';

        setState(() {
          showRetryButton = result.contains('⚠️') ||
                         result.contains('Ошибка') ||
                         result.contains('ошибка') ||
                         result.contains('таймаут') ||
                         result.contains('интернет') ||
                         result.contains('соединение') ||
                         result.isEmpty;
        });

        return result;
      }

      // Обработка ошибок HTTP
      String errorMessage;
      switch (response.statusCode) {
        case 400:
          errorMessage = '⚠️ Ошибка 400: Некорректный запрос.';
          break;
        case 401:
          errorMessage = '⚠️ Ошибка 401: Доступ запрещён. Проверьте ключ API.';
          break;
        case 403:
          errorMessage = '⚠️ Ошибка 403: Недостаточно прав для выполнения запроса.';
          break;
        case 404:
          errorMessage = '⚠️ Ошибка 404: Сервер не найден.';
          break;
        case 413:
          errorMessage = isVideo 
            ? '''⚠️ Ошибка 413: Видео слишком большое для сервера.

Ограничения на сервере:
• Максимальный размер запроса: 10 МБ
• Наше ограничение: 6 МБ (для стабильности)

Рекомендации:
1. Снимайте видео до 10 секунд
2. Используйте хорошее освещение
3. Подойдите ближе к объекту
4. При необходимости используйте фото вместо видео'''
            : '⚠️ Ошибка 413: Изображение слишком большое.';
          break;
        case 429:
          errorMessage = '⚠️ Ошибка 429: Слишком много запросов. Подождите немного.';
          break;
        case 500:
          errorMessage = '⚠️ Ошибка 500: Внутренняя ошибка сервера.';
          break;
        case 502:
          errorMessage = '⚠️ Ошибка 502: Ошибка шлюза. Попробуйте позже.';
          break;
        case 503:
          errorMessage = '⚠️ Ошибка 503: Сервер временно недоступен.';
          break;
        case 504:
          errorMessage = '⚠️ Ошибка 504: Превышено время ожидания сервера.';
          break;
        default:
          errorMessage = '⚠️ Ошибка сервера: ${response.statusCode}';
          break;
      }

      setState(() => showRetryButton = true);
      return errorMessage;
    } 
    on SocketException {
      setState(() => showRetryButton = true);
      return '⚠️ Ошибка: Отсутствует подключение к интернету.';
    } on TimeoutException {
      setState(() => showRetryButton = true);
      return '⚠️ Ошибка: Время ожидания запроса истекло.';
    } on http.ClientException {
      setState(() => showRetryButton = true);
      return '⚠️ Ошибка сети: Интернет был отключён или нестабилен.';
    } on FormatException {
      setState(() => showRetryButton = true);
      return '⚠️ Ошибка формата: Некорректный ответ от сервера.';
    } catch (e) {
      setState(() => showRetryButton = true);
      return '⚠️ Неизвестная ошибка: $e';
    }
  }

  String _processResponse(String text) {
    text = text.trim();
    if (text.isEmpty) return '⚠️ Пустой ответ';
    text = text.replaceAll(RegExp(r'^\d\.\s*', multiLine: true), '');
    text = text.replaceAllMapped(RegExp(r'^Вид:(.*)', multiLine: true), (match) => '🔬 Вид:${match.group(1)}');
    text = text.replaceAllMapped(RegExp(r'^Тип:(.*)', multiLine: true), (match) => '📋 Тип:${match.group(1)}');
    text = text.replaceAllMapped(RegExp(r'^Описание:(.*)', multiLine: true), (match) => '📘 Описание:${match.group(1)}');
    text = text.replaceAllMapped(RegExp(r'^Статус:(.*)', multiLine: true), (match) => '📊 Статус:${match.group(1)}');
    text = text.replaceAllMapped(RegExp(r'^Состояние:(.*)', multiLine: true), (match) => '❤️ Состояние:${match.group(1)}');
    text = text.replaceAllMapped(RegExp(r'^Поведение:(.*)', multiLine: true), (match) => '🎬 Поведение:${match.group(1)}');
    text = text.replaceAllMapped(RegExp(r'^Рекомендации:(.*)', multiLine: true), (match) => '💡 Рекомендации:${match.group(1)}');
    text = text.replaceAllMapped(RegExp(r'^(Источник):(.*)', multiLine: true), (match) => '🌐 ${match.group(1)}:${match.group(2)}');
    text = text.replaceAllMapped(RegExp(r'^\s*[\*\-]\s(.*)', multiLine: true), (match) => '   • ${match.group(1)}');
    return text;
  }

  Future<void> _openCameraAwesome() async {
  if (_isLoading) return;

  try {
    if (!await _checkInternet()) {
      setState(() => _result = '⚠️ Нет интернета');
      return;
    }

    // Разрешения
    final cameraStatus = await Permission.camera.request();
    await Permission.microphone.request();

    if (!cameraStatus.isGranted) {
      setState(() => _result = '⚠️ Предоставьте доступ к камере');
      return;
    }

    // Создаем SensorConfig отдельно для доступа к методам яркости
    final sensorConfig = SensorConfig.single(
      sensor: Sensor.position(SensorPosition.back),
      flashMode: FlashMode.none,
      aspectRatio: CameraAspectRatios.ratio_16_9,
      zoom: 0.0,
    );

    // Создаем глобальный ключ для управления таймером
    final GlobalKey<_VideoRecordingTimerState> timerKey = GlobalKey();

    // Открываем встроенный UI camerawesome
    final MediaCapture? mediaCapture = await Navigator.push<MediaCapture?>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // Сам camerawesome виджет с дефолтным интерфейсом
                CameraAwesomeBuilder.awesome(
                  saveConfig: SaveConfig.photoAndVideo(
                    photoPathBuilder: (List<Sensor> sensors) async {
                      final dir = await getTemporaryDirectory();
                      final path =
                          '${dir.path}/photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
                      if (sensors.length == 1) {
                        return SingleCaptureRequest(path, sensors.first);
                      }
                      return MultipleCaptureRequest({
                        for (final s in sensors)
                          s:
                              '${dir.path}/${s.position == SensorPosition.front ? "front" : "back"}_${DateTime.now().millisecondsSinceEpoch}.jpg'
                      });
                    },
                    videoOptions: VideoOptions(
                      enableAudio: false,
                      ios: CupertinoVideoOptions(fps: 30),
                      android: AndroidVideoOptions(
                        bitrate: 60_000_000,
                        fallbackStrategy: QualityFallbackStrategy.higher,
                      ),
                    ),
                    exifPreferences: ExifPreferences(saveGPSLocation: false),
                  ),
                  sensorConfig: sensorConfig, // Используем созданный config
                  enablePhysicalButton: true,
                  previewFit: CameraPreviewFit.fitWidth,
                  availableFilters: [],
                  topActionsBuilder: (state) {
                    // Отслеживаем состояние записи видео
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      try {
                        if (state is VideoRecordingCameraState) {
                          // Запускаем таймер с небольшой задержкой
                          Future.delayed(const Duration(milliseconds: 200), () {
                            if (timerKey.currentState?.mounted == true) {
                              timerKey.currentState?.startRecording();
                            }
                          });
                        } else {
                          // Останавливаем таймер, если не в режиме записи
                          if (timerKey.currentState?.mounted == true) {
                            timerKey.currentState?.stopRecording();
                          }
                        }
                        
                        // Устанавливаем яркость после инициализации камеры
                        // Ждем немного, чтобы камера точно была готова
                        Future.delayed(const Duration(milliseconds: 800), () {
                          try {
                            // Устанавливаем яркость на 70% для компенсации тусклости
                            sensorConfig.setBrightness(0.7);
                            debugPrint('✅ Яркость видео установлена на 0.7');
                          } catch (e) {
                            debugPrint('⚠️ Не удалось установить яркость: $e');
                            // Попробуем через CameraInterface
                            try {
                              // ignore: unused_local_variable
                              final cameraInterface = CameraInterface();
                              // Проверим доступные методы CameraInterface
                              debugPrint('Пробуем настроить через CameraInterface');
                            } catch (e2) {
                              debugPrint('⚠️ CameraInterface не доступен: $e2');
                            }
                          }
                        });
                      } catch (e) {
                        debugPrint('Ошибка управления таймером/яркостью: $e');
                      }
                    });
                    
                    return Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 16,
                        left: 30,
                        right: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Вспышка слева
                          AwesomeFlashButton(state: state),
                          
                          // Центральная часть - ПУСТОЙ Container при записи
                          if (state is PhotoCameraState)
                            AwesomeAspectRatioButton(state: state)
                          else if (state is VideoCameraState && !(state is VideoRecordingCameraState))
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Видео режим',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'ComicSans',
                                ),
                              ),
                            )
                          else if (state is VideoRecordingCameraState)
                            Container() // ПУСТОЙ контейнер вместо "Запись..."
                          else
                            const Spacer(),
                          
                          // Кнопка закрытия справа
                          GestureDetector(
                            onTap: () {
                              try {
                                timerKey.currentState?.stopRecording();
                              } catch (e) {
                                debugPrint('Ошибка остановки таймера: $e');
                              }
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 49,
                              height: 49,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(24.5),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  // При тапе по превью camerawesome вернёт MediaCapture
                  onMediaTap: (media) {
                    try {
                      timerKey.currentState?.stopRecording();
                    } catch (e) {
                      debugPrint('Ошибка остановки таймера: $e');
                    }
                    Navigator.pop(context, media);
                  },
                ),

                // Таймер записи видео
                _VideoRecordingTimer(key: timerKey),
              ],
            ),
          );
        },
      ),
    );

    // При закрытии камеры очищаем SensorConfig
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        sensorConfig.dispose();
      } catch (e) {
        debugPrint('Ошибка очистки sensorConfig: $e');
      }
    });

    // Пользователь отменил камеру
    if (mediaCapture == null) return;

    // Извлекаем путь к файлу
    String? filePath;
    mediaCapture.captureRequest.when(
      single: (single) {
        filePath = single.file?.path;
      },
      multiple: (multiple) {
        filePath = multiple.fileBySensor.values.first?.path;
      },
    );

    if (filePath == null || filePath!.isEmpty) {
      setState(() {
        _result = '⚠️ Ошибка: не удалось получить путь к файлу.';
      });
      return;
    }

    final file = File(filePath!);
    if (!await file.exists()) {
      setState(() {
        _result = '⚠️ Ошибка: файл не найден.';
      });
      return;
    }

    // Определяем — это видео или фото — по расширению
    final lower = file.path.toLowerCase();
    final isVideo = lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.mkv') ||
        lower.endsWith('.avi');

    // -------------------------
    // Улучшенный экран подтверждения
    // -------------------------
    final bool? userConfirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: screenWidth * 0.95, // Увеличили ширину
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.85,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.95), // Менее прозрачный
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Заголовок
                Padding(
                  padding: const EdgeInsets.all(12), // Уменьшили отступы
                  child: Text(
                    isVideo ? 'ПРЕДПРОСМОТР ВИДЕО' : 'ПРЕДПРОСМОТР ФОТО',
                    style: const TextStyle(
                      fontSize: 18, // Уменьшили размер шрифта
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'ComicSans',
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                
                // Контейнер для медиа - исправлен для заполнения всей области
                Container(
                  height: screenHeight * 0.4, // Адаптивная высота
                  margin: const EdgeInsets.symmetric(horizontal: 8), // Уменьшили отступы
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _MediaPreviewWidget(
                      file: file, 
                      isVideo: isVideo,
                      fillContainer: true, // Добавили параметр для заполнения
                    ),
                  ),
                ),
                
                // Информация о файле - упрощённая версия
                Padding(
                  padding: const EdgeInsets.all(8), // Уменьшили отступы
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isVideo ? Icons.videocam : Icons.photo,
                          color: Colors.green,
                          size: 16, // Уменьшили размер иконки
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isVideo ? 'ВИДЕО' : 'ФОТО',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12, // Уменьшили размер шрифта
                            fontWeight: FontWeight.bold,
                            fontFamily: 'ComicSans',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.sd_storage,
                          color: Colors.green,
                          size: 16, // Уменьшили размер иконки
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${(file.lengthSync() / 1024 / 1024).toStringAsFixed(1)} МБ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12, // Уменьшили размер шрифта
                            fontFamily: 'ComicSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Кнопки - с уменьшенным текстом
                Container(
                  padding: const EdgeInsets.all(12), // Уменьшили отступы
                  child: Row(
                    children: [
                      // Кнопка "Переснять" - с уменьшенным текстом
                      Expanded(
                        child: Container(
                          height: 48, // Уменьшили высоту
                          margin: const EdgeInsets.only(right: 6), // Уменьшили отступ
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red.shade600, Colors.red.shade800],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 4), // Уменьшили отступы
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.refresh, size: 18), // Уменьшили размер иконки
                                SizedBox(width: 6), // Уменьшили отступ
                                Flexible(
                                  child: Text(
                                    'ПЕРЕСНЯТЬ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13, // Уменьшили размер шрифта
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Кнопка "Использовать" - с уменьшенным текстом
                      Expanded(
                        child: Container(
                          height: 48, // Уменьшили высоту
                          margin: const EdgeInsets.only(left: 6), // Уменьшили отступ
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green.shade600, Colors.green.shade800],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 4), // Уменьшили отступы
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, size: 18), // Уменьшили размер иконки
                                SizedBox(width: 6), // Уменьшили отступ
                                Flexible(
                                  child: Text(
                                    'ИСПОЛЬЗОВАТЬ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13, // Уменьшили размер шрифта
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Отступ снизу
                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      },
    );

    // Если пользователь выбрал "Переснять" — открываем камеру заново
    if (userConfirmed == false) {
      await Future.delayed(const Duration(milliseconds: 200));
      await _openCameraAwesome();
      return;
    }

    // Если пользователь подтвердил — продолжаем обработку

    // Проверка длительности видео
    if (isVideo) {
      try {
        final info = await VideoCompress.getMediaInfo(file.path);
        final durationSec = ((info.duration ?? 0) / 1000).round();
        if (durationSec > _maxVideoDuration) {
          _showTimeExceededDialog();
          return;
        }
      } catch (e) {
        debugPrint('Не удалось определить длительность видео: $e');
      }
    }

    // Вызываем обработчик анализа
    await _processMedia(file, isVideo);

    // Сохраняем фото в галерею (если включено)
    if (!isVideo && _saveCameraPhotos) {
      const channel = MethodChannel('com.example.markotkh_guide/media');
      try {
        final fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await channel.invokeMethod('saveToGallery', {'path': file.path, 'name': fileName});
      } catch (e) {
        debugPrint('Ошибка при сохранении в галерею: $e');
      }
    }
  } catch (e, st) {
    debugPrint('Ошибка _openCameraAwesome: $e\n$st');
    setState(() {
      _result = '⚠️ Ошибка камеры: $e';
      _isLoading = false;
    });
  }
}

  Future<void> _pickFromGallery(bool isVideo) async {
    File? selectedFile;

    if (Platform.isWindows) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: isVideo ? FileType.video : FileType.image,
        allowMultiple: false,
      );
      
      if (result != null && result.files.single.path != null) {
        selectedFile = File(result.files.single.path!);
      } else {
        setState(() => _result = '⚠️ Файл не выбран');
        return;
      }
    } else {
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          await openAppSettings();
          setState(() => _result = '⚠️ Разрешение на галерею запрещено.');
        } else {
          setState(() => _result = '⚠️ Предоставьте доступ к галерее');
        }
        return;
      }

      if (isVideo) {
        final List<AssetEntity>? assets = await AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: 1,
            requestType: RequestType.video,
            selectedAssets: [],
            textDelegate: const RussianAssetPickerTextDelegate(),
            pathNameBuilder: (AssetPathEntity path) {
              if (path.isAll || path.name.toLowerCase() == 'recent') {
                return 'Недавние';
              }
              return path.name;
            },
          ),
        );

        if (assets == null || assets.isEmpty) {
          setState(() => _result = '⚠️ Видео не выбрано');
          return;
        }

        selectedFile = await assets.first.file;
        
        // Проверяем длительность видео
        final videoInfo = await VideoCompress.getMediaInfo(selectedFile!.path);
        final durationInSeconds = videoInfo.duration! / 1000;
        
        if (durationInSeconds > _maxVideoDuration) {
          _showTimeExceededDialog();
          return;
        }
      } else {
        final List<AssetEntity>? assets = await AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: 1,
            requestType: RequestType.image,
            selectedAssets: [],
            textDelegate: const RussianAssetPickerTextDelegate(),
            pathNameBuilder: (AssetPathEntity path) {
              if (path.isAll || path.name.toLowerCase() == 'recent') {
                return 'Недавние';
              }
              return path.name;
            },
          ),
        );

        if (assets == null || assets.isEmpty) {
          setState(() => _result = '⚠️ Изображение не выбрано');
          return;
        }

        selectedFile = await assets.first.file;
      }
    }

    if (selectedFile == null) {
      setState(() => _result = '⚠️ Ошибка: Не удалось получить файл');
      return;
    }

    await _processMedia(selectedFile, isVideo);
  }

  Future<void> _processMedia(File file, bool isVideo) async {
  setState(() {
    if (isVideo) {
      _selectedVideo = file;
      _selectedImage = null;
      _videoPlayerController?.pause();
      _videoPlayerController = null;
    } else {
      _selectedImage = file;
      _selectedVideo = null;
      _videoPlayerController?.pause();
      _videoPlayerController = null;
    }
    _isLoading = true;
    _result = '';
    _isCameraSource = true;
    _hasSelectedMedia = true;
    _isVideo = isVideo;
    _imageScaleController.stop();
    _showInspirationalText = false;
  });

  // Для видео - сначала инициализируем, потом анализируем
  if (isVideo) {
    bool initialized = await _initializeVideoController(file);
    if (!initialized) {
      // Если не удалось инициализировать, все равно продолжаем
      print('⚠️ Видео контроллер не инициализирован, но продолжаем анализ');
    }
  }

  // Пауза перед анализом для стабильности
  await Future.delayed(Duration(milliseconds: 500));

  String response;
  String? savedFilePath;
  
  try {
    response = await _analyzeMedia(file, isVideo);
    savedFilePath = isVideo 
      ? await _saveVideoPermanently(file)
      : await _saveImagePermanently(file);
  } catch (e) {
    setState(() {
      _result = '⚠️ Ошибка анализа: $e';
      _isLoading = false;
    });
    return;
  }

  if (savedFilePath == null) {
    setState(() {
      _result = '⚠️ Ошибка: Не удалось сохранить ${isVideo ? 'видео' : 'изображение'}';
      _isLoading = false;
    });
    return;
  }

  // После анализа, если это видео, убедимся что контроллер все еще работает
  if (isVideo && _videoPlayerController != null && _videoPlayerController!.value.isInitialized) {
    // Поставьте видео на паузу в начале
    await _videoPlayerController!.pause();
    await _videoPlayerController!.seekTo(Duration.zero);
  }

  await _handleAnalysisResponse(response, savedFilePath, isVideo);
}

  Future<void> _handleAnalysisResponse(String response, String savedFilePath, bool isVideo) async {
    setState(() async {
      _result = _processResponse(response);
      _species = null;

      final lines = response.split('\n');
      bool isFakeSource = false;
      bool isError = response.contains('⚠️ Ошибка') || 
                     response.contains('Ошибка:') || 
                     response.contains('ошибка') ||
                     response.isEmpty;

      String? type;
      if (!isError) {
        for (var line in lines) {
          if (line.startsWith('1. Вид:') || line.startsWith('🔬 Вид:')) {
            _species = line.replaceAll('1. Вид:', '').replaceAll('🔬 Вид:', '').trim();
          } else if (line.startsWith('2. Тип:') || line.startsWith('📋 Тип:')) {
            type = line.replaceAll('2. Тип:', '').replaceAll('📋 Тип:', '').trim();
          } else if (line.startsWith('🌐 Источник:')) {
            isFakeSource = true;
          } else if (line.contains('На изображении нет животных или растений')) {
            _species = 'Не природа';
          }
        }
        
        if (_species == null && !isError) {
          _species = 'Не природа';
        }
      }

      if (isFakeSource) _isCameraSource = false;

      // Сохраняем в соответствующую историю
      if (!isError && _species != null && _species!.isNotEmpty && type != null) {
        final now = DateTime.now();
        final newEntry = {
          'date': now,
          'species': _species,
          'type': type,
          'result': _result,
          'imagePath': savedFilePath,
          'isVideo': isVideo,
        };

        bool isDuplicate = false;
        if (type.toLowerCase().contains('живот')) {
          isDuplicate = _animalHistory.any((entry) {
            final entryDate = entry['date'] is DateTime ? entry['date'] : DateTime.parse(entry['date'].toString());
            return entryDate.difference(now).inMinutes.abs() < 5 && entry['species'] == _species;
          });
          
          if (!isDuplicate) {
            _animalHistory.add(newEntry);
            await _saveAnimalHistory();
          }
        } else if (type.toLowerCase().contains('растен')) {
          isDuplicate = _plantHistory.any((entry) {
            final entryDate = entry['date'] is DateTime ? entry['date'] : DateTime.parse(entry['date'].toString());
            return entryDate.difference(now).inMinutes.abs() < 5 && entry['species'] == _species;
          });
          
          if (!isDuplicate) {
            _plantHistory.add(newEntry);
            await _savePlantHistory();
          }
        }

        if (!isDuplicate) {
          widget.scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text('Анализ сохранен в историю'), duration: Duration(seconds: 2)),
          );
        }
      }
    });

    setState(() => _isLoading = false);
  }

  void _showTimeExceededDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Превышено время', style: TextStyle(fontFamily: 'ComicSans')),
        content: Text(
          'Видео не должно превышать 1 минуту. Пожалуйста, запишите более короткое видео.',
          style: TextStyle(fontFamily: 'ComicSans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(fontFamily: 'ComicSans')),
          ),
        ],
      ),
    );
  }

  Future<Widget> _getImageWidget(String? path, bool isVideo) async {
  if (path == null) {
    return Icon(isVideo ? Icons.videocam : Icons.photo, color: Colors.green.shade300);
  }
  
  try {
    final file = File(path);
    if (await file.exists()) {
      if (isVideo) {
        // Пробуем получить превью видео
        final thumbnailBytes = await _getVideoThumbnail(file);
        if (thumbnailBytes != null) {
          return Image.memory(
            thumbnailBytes,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildVideoIcon(),
          );
        }
        return _buildVideoIcon();
      } else {
        // Для фото пытаемся загрузить изображение
        return Image.file(
          file, 
          width: 50, 
          height: 50, 
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.photo, color: Colors.green.shade300),
        );
      }
    }
  } catch (e) {
    print('❌ Ошибка загрузки изображения: $e');
  }
  
  return Icon(isVideo ? Icons.videocam : Icons.photo, color: Colors.green.shade300);
}

Widget _buildVideoIcon() {
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      color: Colors.blue.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.blue.shade300),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.videocam, size: 20, color: Colors.blue),
        SizedBox(height: 4),
        Text('ВИДЕО', 
          style: TextStyle(fontSize: 8, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

  // Функция для просмотра изображения/видео в полноэкранном режиме
  void _showFullScreenMedia(File? imageFile, File? videoFile) {
  if (imageFile == null && videoFile == null) return;
  
  if (imageFile != null && !imageFile.existsSync()) return;
  if (videoFile != null && !videoFile.existsSync()) return;
  
  if (videoFile != null) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => FullScreenVideoDialog(videoFile: videoFile),
    );
  } else {
    // Для изображения - оставляем как было
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black87,
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: Center(
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.error, color: Colors.white, size: 50),
                    ),
                  ),
                ),
              ),
            ),
            // Надпись ФОТО вверху слева
            Positioned(
              top: 40,
              left: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.photo, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'ФОТО',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ComicSans',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  
  if (hours > 0) {
    return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
  } else {
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}

  // Функция для поделиться результатом анализа
  void _shareAnalysisResult(Map<String, dynamic> item) async {
    try {
      final String species = item['species'] ?? 'Неизвестный вид';
      final String type = item['type'] ?? '';
      final String result = item['result'] ?? '';
      final String? imagePath = item['imagePath'];
      final bool isVideo = item['isVideo'] ?? false;
      
      String shareText = '''
$species
$type

Результат анализа ${isVideo ? 'видео' : 'фото'}:
$result

📱 Сделано с помощью приложения "Маркотх Гид"
      ''';
      
      List<XFile> files = [];
      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          files.add(XFile(file.path, mimeType: isVideo ? 'video/mp4' : 'image/jpeg'));
        }
      }
      
      await Share.shareXFiles(
        files,
        text: shareText,
        subject: 'Результат анализа: $species',
      );
    } catch (e) {
      widget.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Ошибка при отправке: $e'), duration: Duration(seconds: 2)),
      );
    }
  }

  // ------------------- История животных -------------------
  void _showAnimalHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surface.withOpacity(0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'История животных',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontFamily: 'ComicSans',
                    ),
                  ),
                  const SizedBox(height: 10),
                  _animalHistory.isEmpty
                      ? Container(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.pets, size: 60, color: Colors.grey.shade400),
                                SizedBox(height: 16),
                                Text(
                                  'История животных пуста',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                    fontFamily: 'ComicSans',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Проанализируйте фотографии животных,\nчтобы они появились здесь',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                    fontFamily: 'ComicSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: _animalHistory.length,
                            itemBuilder: (context, index) {
                              final reversedIndex = _animalHistory.length - 1 - index;
                              final item = _animalHistory[reversedIndex];
                              final bool isVideoItem = item['isVideo'] ?? false;
                              return Dismissible(
                                key: Key('${item['date']}_${item['species'] ?? ''}'),
                                background: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(Icons.delete, color: Colors.white, size: 30),
                                ),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (direction) async {
                                  return await showDialog<bool>(
                                    context: context,
                                    builder: (context) => _buildConfirmationDialog(
                                      title: 'Подтвердите удаление',
                                      content: 'Вы действительно хотите удалить этот анализ?',
                                    ),
                                  );
                                },
                                onDismissed: (direction) {
                                  setState(() => _animalHistory.removeAt(reversedIndex));
                                  _saveAnimalHistory();
                                  setDialogState(() {});
                                  widget.scaffoldMessengerKey.currentState?.showSnackBar(
                                    const SnackBar(content: Text('Анализ удален'), duration: Duration(seconds: 2)),
                                  );
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: Theme.of(context).brightness == Brightness.dark
                                              ? [Colors.green.shade900, Colors.green.shade800]
                                              : [Colors.green.shade50, Colors.green.shade100],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          ListTile(
                                            leading: GestureDetector(
                                              onTap: () {
                                                if (item['imagePath'] != null) {
                                                  if (isVideoItem) {
                                                    _showFullScreenMedia(null, File(item['imagePath']));
                                                  } else {
                                                    _showFullScreenMedia(File(item['imagePath']), null);
                                                  }
                                                }
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.green.shade300),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: FutureBuilder<Widget>(
                                                    future: _getImageWidget(item['imagePath'], isVideoItem),
                                                    builder: (context, snapshot) {
                                                      return snapshot.hasData
                                                          ? FittedBox(fit: BoxFit.cover, child: snapshot.data!)
                                                          : Icon(isVideoItem ? Icons.videocam : Icons.photo);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Container(
                                              padding: EdgeInsets.only(right: 50),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item['species'] ?? 'Неизвестный вид',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'ComicSans',
                                                      ),
                                                      overflow: TextOverflow.visible, // Убрали ellipsis
                                                    ),
                                                  ),
                                                  SizedBox(width: 4),
                                                ],
                                              ),
                                            ),
                                            subtitle: Container(
                                              padding: EdgeInsets.only(right: 50),
                                              child: Text(
                                                '${_formatHistoryDate(item['date'])}\nТип: ${item['type'] ?? ''}',
                                                style: TextStyle(
                                                  fontFamily: 'ComicSans',
                                                ),
                                                overflow: TextOverflow.visible, // Убрали ellipsis
                                              ),
                                            ),
                                            onTap: () {
  Navigator.pop(context);
  setState(() {
    if (isVideoItem) {
      _selectedVideo = item['imagePath'] != null ? File(item['imagePath']) : null;
      _selectedImage = null;
      _isVideo = true;
      
      // ДОБАВЛЕНО: Инициализируем видео контроллер при загрузке из истории
      if (_selectedVideo != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _initializeVideoController(_selectedVideo!);
          if (mounted) setState(() {});
        });
      }
    } else {
      _selectedImage = item['imagePath'] != null ? File(item['imagePath']) : null;
      _selectedVideo = null;
      _isVideo = false;
    }
    _result = item['result'];
    _species = item['species'];
    _hasSelectedMedia = (_selectedImage != null) || (_selectedVideo != null);
    if (_hasSelectedMedia) {
      _imageScaleController.stop();
    }
  });
},
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Column(
                                              children: [
                                                // Кнопка удаления
                                                GestureDetector(
                                                  onTap: () async {
                                                    final confirm = await showDialog<bool>(
                                                      context: context,
                                                      builder: (context) => _buildConfirmationDialog(
                                                        title: 'Подтвердите удаление',
                                                        content: 'Вы действительно хотите удалить этот анализ?',
                                                      ),
                                                    );
                                                    if (confirm == true) {
                                                      setState(() => _animalHistory.removeAt(reversedIndex));
                                                      _saveAnimalHistory();
                                                      setDialogState(() {});
                                                      if (mounted) {
                                                        widget.scaffoldMessengerKey.currentState?.showSnackBar(
                                                          const SnackBar(content: Text('Анализ удален'), duration: Duration(seconds: 2)),
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red.withOpacity(0.9),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(Icons.close, size: 18, color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                // Кнопка поделиться
                                                GestureDetector(
                                                  onTap: () => _shareAnalysisResult(item),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue.withOpacity(0.9),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Transform.translate(
                                                      offset: Offset(0, 0),
                                                      child: const Icon(Icons.share, size: 18, color: Colors.white),
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
                                ),
                              );
                            },
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_animalHistory.isNotEmpty)
                          _buildAnimatedDialogButton(
                            text: 'Очистить всё',
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => _buildConfirmationDialog(
                                  title: 'Подтвердите очистку',
                                  content: 'Вы действительно хотите удалить всю историю животных?',
                                ),
                              );
                              if (confirm == true) {
                                setState(() => _animalHistory.clear());
                                await _saveAnimalHistory();
                                if (mounted) {
                                  Navigator.pop(context);
                                  widget.scaffoldMessengerKey.currentState?.showSnackBar(
                                    const SnackBar(content: Text('История успешно очищена'), duration: Duration(seconds: 2)),
                                  );
                                }
                              }
                            },
                            backgroundColor: Colors.red,
                          ),
                        if (_animalHistory.isNotEmpty) const SizedBox(width: 16),
                        _buildAnimatedDialogButton(
                          text: 'Закрыть',
                          onPressed: () => Navigator.pop(context),
                          backgroundColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------- История растений -------------------
  void _showPlantHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surface.withOpacity(0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'История растений',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontFamily: 'ComicSans',
                    ),
                  ),
                  const SizedBox(height: 10),
                  _plantHistory.isEmpty
                      ? Container(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.local_florist, size: 60, color: Colors.grey.shade400),
                                SizedBox(height: 16),
                                Text(
                                  'История растений пуста',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                    fontFamily: 'ComicSans',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Проанализируйте фотографии растений,\nчтобы они появились здесь',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                    fontFamily: 'ComicSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: _plantHistory.length,
                            itemBuilder: (context, index) {
                              final reversedIndex = _plantHistory.length - 1 - index;
                              final item = _plantHistory[reversedIndex];
                              final bool isVideoItem = item['isVideo'] ?? false;
                              return Dismissible(
                                key: Key('${item['date']}_${item['species'] ?? ''}'),
                                background: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(Icons.delete, color: Colors.white, size: 30),
                                ),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (direction) async {
                                  return await showDialog<bool>(
                                    context: context,
                                    builder: (context) => _buildConfirmationDialog(
                                      title: 'Подтвердите удаление',
                                      content: 'Вы действительно хотите удалить этот анализ?',
                                    ),
                                  );
                                },
                                onDismissed: (direction) {
                                  setState(() => _plantHistory.removeAt(reversedIndex));
                                  _savePlantHistory();
                                  setDialogState(() {});
                                  widget.scaffoldMessengerKey.currentState?.showSnackBar(
                                    const SnackBar(content: Text('Анализ удален'), duration: Duration(seconds: 2)),
                                  );
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: Theme.of(context).brightness == Brightness.dark
                                              ? [Colors.green.shade900, Colors.green.shade800]
                                              : [Colors.green.shade50, Colors.green.shade100],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          ListTile(
                                            leading: GestureDetector(
                                              onTap: () {
                                                if (item['imagePath'] != null) {
                                                  if (isVideoItem) {
                                                    _showFullScreenMedia(null, File(item['imagePath']));
                                                  } else {
                                                    _showFullScreenMedia(File(item['imagePath']), null);
                                                  }
                                                }
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.green.shade300),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: FutureBuilder<Widget>(
                                                    future: _getImageWidget(item['imagePath'], isVideoItem),
                                                    builder: (context, snapshot) {
                                                      return snapshot.hasData
                                                          ? FittedBox(fit: BoxFit.cover, child: snapshot.data!)
                                                          : Icon(isVideoItem ? Icons.videocam : Icons.photo);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Container(
                                              padding: EdgeInsets.only(right: 50),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item['species'] ?? 'Неизвестный вид',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'ComicSans',
                                                      ),
                                                      overflow: TextOverflow.visible, // Убрали ellipsis
                                                    ),
                                                  ),
                                                  SizedBox(width: 4),
                                                ],
                                              ),
                                            ),
                                            subtitle: Container(
                                              padding: EdgeInsets.only(right: 50),
                                              child: Text(
                                                '${_formatHistoryDate(item['date'])}\nТип: ${item['type'] ?? ''}',
                                                style: TextStyle(
                                                  fontFamily: 'ComicSans',
                                                ),
                                                overflow: TextOverflow.visible, // Убрали ellipsis
                                              ),
                                            ),
                                            onTap: () {
  Navigator.pop(context);
  setState(() {
    if (isVideoItem) {
      _selectedVideo = item['imagePath'] != null ? File(item['imagePath']) : null;
      _selectedImage = null;
      _isVideo = true;
      
      // ДОБАВЛЕНО: Инициализируем видео контроллер при загрузке из истории
      if (_selectedVideo != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _initializeVideoController(_selectedVideo!);
          if (mounted) setState(() {});
        });
      }
    } else {
      _selectedImage = item['imagePath'] != null ? File(item['imagePath']) : null;
      _selectedVideo = null;
      _isVideo = false;
    }
    _result = item['result'];
    _species = item['species'];
    _hasSelectedMedia = (_selectedImage != null) || (_selectedVideo != null);
    if (_hasSelectedMedia) {
      _imageScaleController.stop();
    }
  });
},
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Column(
                                              children: [
                                                // Кнопка удаления
                                                GestureDetector(
                                                  onTap: () async {
                                                    final confirm = await showDialog<bool>(
                                                      context: context,
                                                      builder: (context) => _buildConfirmationDialog(
                                                        title: 'Подтвердите удаление',
                                                        content: 'Вы действительно хотите удалить этот анализ?',
                                                      ),
                                                    );
                                                    if (confirm == true) {
                                                      setState(() => _plantHistory.removeAt(reversedIndex));
                                                      _savePlantHistory();
                                                      setDialogState(() {});
                                                      if (mounted) {
                                                        widget.scaffoldMessengerKey.currentState?.showSnackBar(
                                                          const SnackBar(content: Text('Анализ удален'), duration: Duration(seconds: 2)),
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red.withOpacity(0.9),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(Icons.close, size: 18, color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                // Кнопка поделиться
                                                GestureDetector(
                                                  onTap: () => _shareAnalysisResult(item),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue.withOpacity(0.9),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Transform.translate(
                                                      offset: Offset(0, 0),
                                                      child: const Icon(Icons.share, size: 18, color: Colors.white),
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
                                ),
                              );
                            },
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_plantHistory.isNotEmpty)
                          _buildAnimatedDialogButton(
                            text: 'Очистить всё',
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => _buildConfirmationDialog(
                                  title: 'Подтвердите очистку',
                                  content: 'Вы действительно хотите удалить всю историю растений?',
                                ),
                              );
                              if (confirm == true) {
                                setState(() => _plantHistory.clear());
                                await _savePlantHistory();
                                if (mounted) {
                                  Navigator.pop(context);
                                  widget.scaffoldMessengerKey.currentState?.showSnackBar(
                                    const SnackBar(content: Text('История успешно очищена'), duration: Duration(seconds: 2)),
                                  );
                                }
                              }
                            },
                            backgroundColor: Colors.red,
                          ),
                        if (_plantHistory.isNotEmpty) const SizedBox(width: 16),
                        _buildAnimatedDialogButton(
                          text: 'Закрыть',
                          onPressed: () => Navigator.pop(context),
                          backgroundColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedDialogButton({required String text, required VoidCallback onPressed, required Color backgroundColor}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: backgroundColor.withOpacity(0.4), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'ComicSans')),
      ),
    ).animate(effects: [ScaleEffect(duration: 300.ms)]);
  }

  Widget _buildConfirmationDialog({required String title, required String content}) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.surface.withOpacity(0.9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'ComicSans')),
            SizedBox(height: 16),
            Text(content, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'ComicSans')),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedDialogButton(text: 'Да', onPressed: () => Navigator.pop(context, true), backgroundColor: Colors.green),
                SizedBox(width: 16),
                _buildAnimatedDialogButton(text: 'Нет', onPressed: () => Navigator.pop(context, false), backgroundColor: Colors.red),
              ],
            ),
          ],
        ),
      ),
    ).animate(effects: [ScaleEffect(duration: 500.ms, curve: Curves.elasticOut), FadeEffect(duration: 400.ms)]);
  }

  List<TextSpan> _buildTextSpans(String text) {
    final lines = text.split('\n');
    final spans = <TextSpan>[];
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.contains('•')) {
        final parts = line.split('•');
        spans.add(TextSpan(text: parts[0], style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontFamily: 'ComicSans')));
        spans.add(TextSpan(text: '• ', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontFamily: 'ComicSans')));
        spans.add(TextSpan(text: parts[1].trim(), style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontFamily: 'ComicSans')));
      } else {
        spans.add(TextSpan(text: line, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontFamily: 'ComicSans')));
      }
      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }
    return spans;
  }

  @override
Widget build(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final colorScheme = Theme.of(context).colorScheme;
  final bottomPadding = MediaQuery.of(context).padding.bottom; // Получаем высоту системной навигации
  
  return Scaffold(
    key: _scaffoldKey,
    drawer: _buildAnimatedDrawer(isDarkMode, colorScheme),
    drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.3,
    drawerEnableOpenDragGesture: true,
    appBar: _buildAnimatedAppBar(isDarkMode),
    body: SafeArea( // Добавляем SafeArea для всего body
      bottom: false, // Не применяем SafeArea снизу, так как мы будем сами обрабатывать отступ
      child: Column(
        children: [
          // Основная область с изображением/видео
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDarkMode
                      ? [Color(0xFF0A2A0A), Color(0xFF1A3A1A), Color(0xFF2A4A2A)]
                      : [Colors.green.shade50, Colors.green.shade100, Colors.white],
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedMediaContainer(isDarkMode, colorScheme),
                      if (_showInspirationalText && !_hasSelectedMedia && _result.isEmpty && !_isLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Природа ждет твоего любопытного взгляда",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontFamily: 'ComicSans',
                          ),
                        ).animate(effects: [FadeEffect(duration: 500.ms)]),
                      ),
                      const SizedBox(height: 30),
                      if (_result.isNotEmpty || _isLoading) 
                        _buildAnimatedResultContainer(isDarkMode, colorScheme),
                    ].animate(interval: 100.ms).slideX(begin: 0.1, end: 0, curve: Curves.easeOut),
                  ),
                ),
              ),
            ),
          ),
          
          // Нижняя панель с кнопками
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: 20 + bottomPadding, // Добавляем отступ для системной навигации
            ),
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF0A2A0A).withOpacity(0.8) : Colors.white.withOpacity(0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: _buildAnimatedButtons(isDarkMode, colorScheme),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildAnimatedDrawer(bool isDarkMode, ColorScheme colorScheme) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [Color(0xFF0A2A0A), Color(0xFF1A3A1A)]
                : [Colors.green.shade50, Colors.green.shade100],
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [Colors.green.shade900, Colors.green.shade700]
                      : [Colors.green.shade400, Colors.green.shade700],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome , size: 60, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'Маркотх Гид',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'ComicSans',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Приложение для определения животных и растений по фото и видео. '
                        'Открывайте для себя удивительный мир природы.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          fontFamily: 'ComicSans',
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ).animate(effects: [ScaleEffect(duration: 600.ms)]),

            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 8),
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Icon(
                      Icons.pets,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      size: 28,
                    ),
                    title: Text(
                      'История животных',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'ComicSans',
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showAnimalHistoryDialog();
                    },
                  ).animate(delay: 250.ms).fadeIn().slideX(begin: -0.1, end: 0),

                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Icon(
                      Icons.local_florist,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      size: 28,
                    ),
                    title: Text(
                      'История растений',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'ComicSans',
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showPlantHistoryDialog();
                    },
                  ).animate(delay: 250.ms).fadeIn().slideX(begin: -0.1, end: 0),
                ],
              ),
            ),

            SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.only(bottom: 30.0, left: 16, right: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF006400) : Colors.green,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _navigateToSettings(isDarkMode),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.settings, color: Colors.white, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            'Настройки',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'ComicSans',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAnimatedAppBar(bool isDarkMode) {
    return AppBar(
      title: Text(
        'Определитель видов',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          shadows: [Shadow(blurRadius: 10, color: Colors.green.withOpacity(0.3), offset: Offset(0, 2))],
          fontFamily: 'ComicSans',
        ),
      ).animate(effects: [FadeEffect(duration: 800.ms), SlideEffect(begin: Offset(0, -0.5), curve: Curves.easeOut)]),
      leading: IconButton(icon: Icon(Icons.menu_rounded), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode ? [Color(0xFF0A2A0A), Color(0xFF1A3A1A)] : [Colors.white, Colors.green.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 0,
    );
  }

  Widget _buildAnimatedMediaContainer(bool isDarkMode, ColorScheme colorScheme) {
  return GestureDetector(
    onTap: () {
      if (_hasSelectedMedia && _isVideo && _videoPlayerController != null) {
        _showFullScreenMedia(null, _selectedVideo);
      } else if (_hasSelectedMedia && !_isVideo) {
        _showFullScreenMedia(_selectedImage, null);
      }
    },
    onLongPress: () {
      if (_hasSelectedMedia || _result.isNotEmpty) {
        _resetAnalysis();
        widget.scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Анализ очищен'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    },
    child: _hasSelectedMedia
        ? Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Основное содержимое
                  if (_isVideo && _selectedVideo != null)
                    _buildVideoPreview()
                  else if (_selectedImage != null)
                    _buildImagePreview()
                  else
                    _buildPlaceholder(colorScheme),
                ],
              ),
            ),
          )
        : _buildPlaceholderAnimation(isDarkMode, colorScheme),
  );
}

Widget _buildVideoPreview() {
  return Stack(
    children: [
      // Видео или его превью
      Positioned.fill(
        child: _videoPlayerController != null && 
               _videoPlayerController!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController!),
              )
            : FutureBuilder<Uint8List?>(
                future: _selectedVideo != null ? _getVideoThumbnail(_selectedVideo!) : null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data != null) {
                    return Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    );
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 10),
                        Text(
                          'Загрузка видео...',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'ComicSans',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      
      // Overlay
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
      ),
      
      // Метка ВИДЕО вверху слева
      Positioned(
        top: 10,
        left: 10,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.videocam, size: 14, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'ВИДЕО',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicSans',
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Кнопка Play/Pause
      Positioned.fill(
        child: Center(
          child: GestureDetector(
            onTap: () async {
              if (_videoPlayerController != null && 
                  _videoPlayerController!.value.isInitialized) {
                if (_videoPlayerController!.value.isPlaying) {
                  await _safePauseVideo();
                } else {
                  await _safePlayVideo();
                }
              }
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Icon(
                _videoPlayerController != null && 
                _videoPlayerController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ),
      
      // Полоска прогресса
      if (_videoPlayerController != null && 
          _videoPlayerController!.value.isInitialized)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: VideoProgressIndicator(
            _videoPlayerController!,
            allowScrubbing: true,
            colors: VideoProgressColors(
              playedColor: Colors.green,
              bufferedColor: Colors.green.shade300,
              backgroundColor: Colors.green.shade100,
            ),
          ),
        ),
      
      // Инструкция с фоном как Colors.black54
Positioned(
  bottom: 10,
  left: 0,
  right: 0,
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    margin: EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Нажмите для просмотра',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'ComicSans',
          ),
        ),
        Text(
          'Удерживайте для сброса',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'ComicSans',
          ),
        ),
      ],
    ),
  ),
),
    ],
  );
}

Widget _buildImagePreview() {
  return Stack(
    children: [
      Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPlaceholder('Ошибка загрузки изображения');
        },
      ),
      // Метка ФОТО вверху слева
      Positioned(
        top: 10,
        left: 10,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.photo, size: 14, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'ФОТО',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicSans',
                ),
              ),
            ],
          ),
        ),
      ),
      // Инструкция с фоном как Colors.black54
Positioned(
  bottom: 10,
  left: 0,
  right: 0,
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    margin: EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Нажмите для просмотра',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'ComicSans',
          ),
        ),
        Text(
          'Удерживайте для сброса',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'ComicSans',
          ),
        ),
      ],
    ),
  ),
),
    ],
  );
}

Future<Uint8List?> _getVideoThumbnail(File videoFile) async {
  try {
    final thumbnail = await VideoCompress.getFileThumbnail(
      videoFile.path,
      quality: 50,
      position: 0, // Первый кадр
    );
    return await thumbnail.readAsBytes();
  } catch (e) {
    print('Ошибка получения превью видео: $e');
    return null;
  }
}

// Добавьте эти вспомогательные методы в класс:
Widget _buildErrorPlaceholder(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, color: Colors.red, size: 50),
        SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'ComicSans',
          ),
        ),
      ],
    ),
  );
}

Widget _buildPlaceholder(ColorScheme colorScheme) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.eco, size: 80, color: Colors.green.withOpacity(0.7)),
        SizedBox(height: 16),
        Text(
          'Загрузите изображение или видео животного или растения',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.w600, 
            color: colorScheme.onSurface.withOpacity(0.8),
            fontFamily: 'ComicSans',
          ),
        ),
      ],
    ),
  );
}

Widget _buildPlaceholderAnimation(bool isDarkMode, ColorScheme colorScheme) {
  return ScaleTransition(
    scale: _imageScaleAnimation,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode ? [Color(0xFF1A3A1A), Color(0xFF2A4A2A)] : [Colors.green.shade100, Colors.green.shade200],
        ),
        boxShadow: [BoxShadow(color: Colors.green.withOpacity(isDarkMode ? 0.3 : 0.2), blurRadius: 20, offset: Offset(0, 10))],
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 2),
      ),
      child: _buildPlaceholder(colorScheme),
    ),
  ).animate(effects: [ScaleEffect(duration: 600.ms, curve: Curves.elasticOut), FadeEffect(duration: 800.ms)]);
}

Future<bool> _initializeVideoController(File videoFile) async {
  try {
    // Если уже есть контроллер для того же файла - используем его
    if (_videoPlayerController != null && 
        _videoPlayerController!.dataSource == videoFile.path) {
      if (!_videoPlayerController!.value.isInitialized) {
        await _videoPlayerController!.initialize();
      }
      // ДОБАВЛЕНО: Убеждаемся, что видео воспроизводится
      await _videoPlayerController!.seekTo(Duration.zero);
      await _videoPlayerController!.pause(); // Ставим на паузу
      return true;
    }
    
    // Очищаем старый контроллер
    if (_videoPlayerController != null) {
      await _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }
    
    // Проверяем существование файла
    if (!await videoFile.exists()) {
      print('❌ Видеофайл не существует: ${videoFile.path}');
      return false;
    }
    
    _videoPlayerController = VideoPlayerController.file(videoFile);
    
    // Инициализируем с таймаутом
    await _videoPlayerController!.initialize().timeout(
      Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('Таймаут инициализации видео');
      },
    );
    
    // Настраиваем
    _videoPlayerController!.setLooping(true);
    _videoPlayerController!.setVolume(0.0);
    
    // Сразу ставим на паузу и возвращаем к началу
    await _videoPlayerController!.pause();
    await _videoPlayerController!.seekTo(Duration.zero);
    
    // Добавляем слушатель для обновления UI
    _videoPlayerController!.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    
    print('✅ Видео контроллер инициализирован: ${_videoPlayerController!.value.duration}');
    return true;
    
  } catch (e, stackTrace) {
    print('❌ Ошибка инициализации видео контроллера: $e');
    print('Stack trace: $stackTrace');
    
    // Если есть старая ссылка - очищаем
    if (_videoPlayerController != null) {
      await _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }
    
    return false;
  }
}

  Widget _buildAnimatedButtons(bool isDarkMode, ColorScheme colorScheme) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _buildAnimatedButton(
            onPressed: _isLoading ? null : _openCameraAwesome, 
            icon: Icons.camera_alt_rounded, 
            text: "Камера", 
            isDarkMode: isDarkMode
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _buildAnimatedButton(
            onPressed: _isLoading ? null : () => _pickFromGallery(false), 
            icon: Icons.photo_library_rounded, 
            text: "Галерея", 
            isDarkMode: isDarkMode
          ),
        ),
      ),
    ],
  );
}

  Widget _buildAnimatedButton({required VoidCallback? onPressed, required IconData icon, required String text, required bool isDarkMode}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null
              ? Colors.grey.shade400.withOpacity(0.5)
              : (isDarkMode ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.8)),
          foregroundColor: onPressed == null
              ? Colors.grey.shade600
              : (isDarkMode ? Colors.white : Colors.green.shade800),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: onPressed == null 
                ? Colors.transparent 
                : (isDarkMode ? Colors.white.withOpacity(0.3) : Colors.green.shade300.withOpacity(0.5)),
              width: 1,
            ),
          ),
          elevation: 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28),
            SizedBox(height: 8),
            Text(
              text, 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w600,
                fontFamily: 'ComicSans',
              ),
            ),
          ],
        ),
      ),
    ).animate(effects: [ScaleEffect(duration: 400.ms, curve: Curves.elasticOut), FadeEffect(duration: 600.ms)]);
  }

  Widget _buildAnimatedResultContainer(bool isDarkMode, ColorScheme colorScheme) {
    bool showRetryButton = _result.contains('⚠️') || 
                          _result.contains('Ошибка') ||
                          _result.contains('ошибка') ||
                          _result.contains('таймаут') ||
                          _result.contains('интернет') ||
                          _result.contains('соединение');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode ? [Color(0xFF1A3A1A), Color(0xFF2A4A2A)] : [Colors.white, Colors.green.shade50],
        ),
        boxShadow: [BoxShadow(color: Colors.green.withOpacity(isDarkMode ? 0.2 : 0.1), blurRadius: 20, offset: Offset(0, 10))],
        border: Border.all(color: Colors.green.withOpacity(0.2), width: 1),
      ),
      child: _isLoading
          ? Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: Lottie.asset(
                'assets/animations/Animation.json',
                repeat: true,
                frameRate: FrameRate(60),
                fit: BoxFit.contain,
              ),
            ),
          )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '🧠 Результаты анализа',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: colorScheme.primary,
                      fontFamily: 'ComicSans',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.5), 
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: SelectableText.rich(
                    TextSpan(children: _buildTextSpans(_result)),
                    style: TextStyle(fontSize: 16, height: 1.4, fontFamily: 'ComicSans'),
                  ),
                ),
                
                if (showRetryButton && (_selectedImage != null || _selectedVideo != null))
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                            _result = '';
                          });

                          String response;
                          String? savedFilePath;
                          
                          if (_isVideo && _selectedVideo != null) {
                            response = await _analyzeMedia(_selectedVideo!, true);
                            savedFilePath = await _saveVideoPermanently(_selectedVideo!);
                          } else if (_selectedImage != null) {
                            response = await _analyzeMedia(_selectedImage!, false);
                            savedFilePath = await _saveImagePermanently(_selectedImage!);
                          } else {
                            setState(() {
                              _result = '⚠️ Ошибка: Нет данных для анализа';
                              _isLoading = false;
                            });
                            return;
                          }

                          if (savedFilePath == null) {
                            setState(() {
                              _result = '⚠️ Ошибка: Не удалось сохранить ${_isVideo ? 'видео' : 'изображение'}';
                              _isLoading = false;
                            });
                            return;
                          }

                          await _handleAnalysisResponse(response, savedFilePath, _isVideo);
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Повторный анализ', style: TextStyle(fontFamily: 'ComicSans')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    ).animate(effects: [ScaleEffect(duration: 600.ms, curve: Curves.elasticOut), FadeEffect(duration: 800.ms)]);
  }

  void _navigateToSettings(bool isDarkMode) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SettingsScreen(
          onThemeToggle: widget.onThemeToggle,
          isDarkMode: isDarkMode,
          onSaveCameraPhotosToggle: _saveCameraPhotosSetting,
          saveCameraPhotos: _saveCameraPhotos,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          );
        },
      ),
    );
  }
}

// Виджет красного таймера для записи видео
class _VideoRecordingTimer extends StatefulWidget {
  const _VideoRecordingTimer({Key? key}) : super(key: key);
  
  @override
  State<_VideoRecordingTimer> createState() => _VideoRecordingTimerState();
}

class _VideoRecordingTimerState extends State<_VideoRecordingTimer> {
  Duration _recordingDuration = Duration.zero;
  Timer? _timer;
  bool _isRecording = false;
  
  @override
  void initState() {
    super.initState();
  }
  
  void startRecording() {
    if (_isRecording) return;
    
    setState(() {
      _recordingDuration = Duration.zero;
      _isRecording = true;
    });
    
    // Запускаем таймер
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _isRecording) {
        setState(() {
          _recordingDuration = _recordingDuration + const Duration(seconds: 1);
        });
      }
    });
  }
  
  void stopRecording() {
    _timer?.cancel();
    setState(() {
      _isRecording = false;
    });
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
  
  @override
  Widget build(BuildContext context) {
    // Показываем только когда идет запись
    if (!_isRecording) {
      return const SizedBox();
    }
    
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Мигающая красная точка
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _timer != null && _timer!.isActive && _timer!.tick % 2 == 0
                      ? Colors.white
                      : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Таймер
              Text(
                _formatDuration(_recordingDuration),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicSans',
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Индикатор записи
              Text(
                'ЗАПИСЬ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'ComicSans',
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Вспомогательный виджет для предпросмотра видео
class _VideoPreviewWidget extends StatefulWidget {
  final File file;

  const _VideoPreviewWidget({required this.file});

  @override
  State<_VideoPreviewWidget> createState() => _VideoPreviewWidgetState();
}

class _VideoPreviewWidgetState extends State<_VideoPreviewWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.file(widget.file);
    await _controller!.initialize();

    setState(() => _isInitialized = true);

    _controller!.play();
    await Future.delayed(const Duration(seconds: 2));
    _controller!.pause();
    _controller!.seekTo(Duration.zero);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Stack(
      children: [
        // ---------------- ВИДЕО БЕЗ ЧЁРНЫХ ПОЛОС ----------------
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),
        ),

        // ---------------- КНОПКА PLAY/PAUSE ----------------
        Center(
          child: GestureDetector(
            onTap: () async {
              if (_controller!.value.isPlaying) {
                await _controller!.pause();
              } else {
                await _controller!.play();
              }
              setState(() {});
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),

        // ---------------- ИКОНКА "ВИДЕО" ----------------
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.videocam,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),

        // ---------------- ДЛИТЕЛЬНОСТЬ ----------------
        Positioned(
          bottom: 14,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Builder(
              builder: (context) {
                final d = _controller!.value.duration;
                final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
                final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
                return Text(
                  '$m:$s',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ),

        // ---------------- ЗЕЛЁНАЯ ПОЛОСКА ПРОГРЕССА ----------------
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: StreamBuilder(
            stream: _controller!.position.asStream(),
            builder: (context, snap) {
              final pos = snap.data ?? Duration.zero;
              final total = _controller!.value.duration;

              double progress = 0;
              if (total.inMilliseconds > 0) {
                progress =
                    pos.inMilliseconds / total.inMilliseconds;
              }

              return Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.3),
                ),
                child: FractionallySizedBox(
                  widthFactor: progress,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    color: Colors.green,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// =============== НАСТРОЙКИ ===============
class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final bool isDarkMode;
  final Function(bool) onSaveCameraPhotosToggle;
  final bool saveCameraPhotos;
  const SettingsScreen({
    Key? key,
    required this.onThemeToggle,
    required this.isDarkMode,
    required this.onSaveCameraPhotosToggle,
    required this.saveCameraPhotos,
  }) : super(key: key);
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDark;
  late bool _savePhotos;
  // ignore: unused_field
  bool _isLoadingImage = true;
  late ImageProvider _kubguImage;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDarkMode;
    _savePhotos = widget.saveCameraPhotos;
    
    // Инициализируем изображение
    _kubguImage = const AssetImage('assets/icon/app_kubgu.jpg');
    
    // Предзагружаем изображение
    _precacheImage();
  }

  Future<void> _precacheImage() async {
    try {
      await precacheImage(_kubguImage, context);
      setState(() {
        _isLoadingImage = false;
      });
    } catch (e) {
      print('⚠️ Ошибка загрузки изображения КубГУ: $e');
      setState(() {
        _isLoadingImage = false;
      });
    }
  }

  void _onThemeChanged(bool value) {
    setState(() => _isDark = value);
    widget.onThemeToggle(value);
  }

  void _onSavePhotosChanged(bool value) {
    setState(() => _savePhotos = value);
    widget.onSaveCameraPhotosToggle(value);
  }

  void _showHelpDialog(BuildContext context) {
    final textColor = _isDark ? Colors.white : Colors.black;
    final subTextColor = _isDark ? Colors.white70 : Colors.black87;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Подробная справка по приложению',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'ComicSans'),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                _buildHelpSection('🎯 Краткая цель', '«Маркотх Гид» — это мобильное приложение, созданное для быстрого и точного определения видов животных и растений по фотографии или видео. Приложение подходит как для любителей природы, так и для профессиональных биологов.', subTextColor),
                _buildHelpSection('📱 Как это работает — пошагово', '• Сделайте фотографию или видео (до 1 минуты) животного или растения с камеры или загрузите из галереи\n• Изображение или видео обрабатывается нейросетью — определяется вид, особенности и характеристики\n• Вы получаете развернутую карточку с результатом: название вида (рус./англ.), ключевые признаки, среда обитания и охранный статус\n• Для видео: дополнительно анализируется поведение организма', subTextColor),
                _buildHelpSection('🔍 Что именно анализируется', '• Внешние признаки: форма, цвет, размер, текстура\n• Характерные особенности вида\n• Среда обитания и распространение\n• Охранный статус и редкость вида\n• Состояние организма (отличное/удовлетворительное/плохое)\n• Для видео: поведение, движения, активность', subTextColor),
                _buildHelpSection('📖 История и приватность', 'Все результаты анализов сохраняются локально на устройстве (история доступна в разделе «История животных» и «История растений»). Данные не передаются третьим лицам.', subTextColor),
                _buildHelpSection('💡 Советы для хорошего анализа', '• Сфотографируйте/заснимите объект крупно, в фокусе и при хорошем освещении\n• Сделайте несколько кадров с разных ракурсов, если возможно\n• Убедитесь, что ключевые признаки хорошо видны на фото/видео\n• Для растений: постарайтесь захватить цветы, листья и стебель\n• Для видео: максимальная длительность — 1 минута', subTextColor),
                _buildHelpSection('⚠️ Частые проблемы и решения', '• Если приложение не распознаёт вид — попробуйте другое фото/видео с чётким ракурсом\n• Если анализ не работает — проверьте подключение к интернету\n• Если вы видите ложные детекции — выберите более качественное изображение\n• Если видео слишком длинное — обрежьте его до 1 минута', subTextColor),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    '✨ Наслаждайтесь изучением природы с Маркотх Гид!',
                    style: TextStyle(color: subTextColor, fontWeight: FontWeight.bold, fontFamily: 'ComicSans', fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection(String title, String content, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            title, 
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold, 
              color: _isDark ? Colors.white : Colors.black,
              fontFamily: 'ComicSans',
            ), 
            textAlign: TextAlign.left
          ),
        ),
        const SizedBox(height: 8),
        Text(content, style: TextStyle(color: textColor, height: 1.4, fontFamily: 'ComicSans')),
        const SizedBox(height: 20),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.grey.shade700;
    final accentColor = isDark ? Colors.blue.shade300 : Colors.blue.shade700;
    final cardColor = isDark ? const Color(0xFF16213E) : Colors.blue.shade50;
    
    showDialog(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final padding = screenWidth < 400 ? 16.0 : 24.0;
        final titleFontSize = screenWidth < 400 ? 20.0 : 24.0;
        final normalFontSize = screenWidth < 400 ? 13.0 : 14.0;
        
        return Dialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: accentColor.withOpacity(0.3), width: 2),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: EdgeInsets.all(padding),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Заголовок
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade800, Colors.blue.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'О приложении',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'ComicSans',
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Изображение филиала КубГУ с динамическим определением размеров
FutureBuilder<ImageInfo>(
  future: _getImageInfo(_kubguImage),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: accentColor.withOpacity(0.3), width: 2),
          color: cardColor,
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: accentColor,
          ),
        ),
      );
    }
    
    if (snapshot.hasError || snapshot.data == null) {
      return Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: accentColor.withOpacity(0.3), width: 2),
          color: cardColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 60,
              color: accentColor,
            ),
            const SizedBox(height: 10),
            Text(
              'КубГУ в Геленджике',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: accentColor,
                fontFamily: 'ComicSans',
              ),
            ),
          ],
        ),
      );
    }
    
    final imageInfo = snapshot.data!;
    final imageWidth = imageInfo.image.width.toDouble();
    final imageHeight = imageInfo.image.height.toDouble();
    final aspectRatio = imageWidth / imageHeight;
    
    // Определяем максимальные размеры
    final maxWidth = screenWidth * 0.85; // 85% ширины экрана
    final maxHeight = 200.0;
    
    // Рассчитываем размеры с сохранением пропорций
    double containerWidth;
    double containerHeight;
    
    if (imageWidth > imageHeight) {
      // Горизонтальное изображение
      containerWidth = maxWidth;
      containerHeight = containerWidth / aspectRatio;
      if (containerHeight > maxHeight) {
        containerHeight = maxHeight;
        containerWidth = containerHeight * aspectRatio;
      }
    } else {
      // Вертикальное изображение
      containerHeight = maxHeight;
      containerWidth = containerHeight * aspectRatio;
      if (containerWidth > maxWidth) {
        containerWidth = maxWidth;
        containerHeight = containerWidth / aspectRatio;
      }
    }
    
    // Убедимся, что размеры не меньше минимальных
    containerWidth = containerWidth.clamp(100.0, maxWidth);
    containerHeight = containerHeight.clamp(100.0, maxHeight);
    
    return Container(
      width: containerWidth,
      height: containerHeight,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Image(
          image: _kubguImage,
          width: containerWidth,
          height: containerHeight,
          fit: BoxFit.cover, // Используем cover для заполнения контейнера
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: containerWidth,
              height: containerHeight,
              color: cardColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school,
                    size: 60,
                    color: accentColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'КубГУ в Геленджике',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                      fontFamily: 'ComicSans',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  },
),
                  
                  const SizedBox(height: 8),
                  
                  // Название под изображением
// Измените эту часть кода в методе _showAboutDialog
Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  decoration: BoxDecoration(
    color: accentColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: accentColor.withOpacity(0.2)),
  ),
  child: Column(
    children: [
      // Заголовок "Разработано в:" с увеличенным размером
      Text(
        'Разработано в филиале:',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: screenWidth < 400 ? 18.0 : 20.0, // Увеличили размер
          fontWeight: FontWeight.w600,
          color: subTextColor.withOpacity(0.9),
          fontFamily: 'ComicSans',
        ),
      ),
      const SizedBox(height: 6), // Увеличили отступ
      Text(
        '"Кубанский Государственный Университет"',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: screenWidth < 400 ? 15.0 : 17.0, // Увеличили размер
          fontWeight: FontWeight.bold,
          color: accentColor,
          fontFamily: 'ComicSans',
        ),
      ),
      const SizedBox(height: 4),
      Text(
        'в г. Геленджике',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: screenWidth < 400 ? 13.0 : 15.0, // Увеличили размер
          color: subTextColor,
          fontFamily: 'ComicSans',
          fontStyle: FontStyle.italic
        ),
      ),
      const SizedBox(height: 2),
      Text(
        '(КубГУ в г. Геленджике)',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: screenWidth < 400 ? 12.0 : 14.0, // Увеличили размер
          color: subTextColor.withOpacity(0.8),
          fontFamily: 'ComicSans',
        ),
      ),
    ],
  ),
),
                  
                  const SizedBox(height: 20),
                  
                  // Описание - ВЕРНУЛИ ВЫРАВНИВАНИЕ СЛЕВА
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(15),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start, // ВЕРНУЛИ НА start
    children: [
      Row(
        children: [
          Icon(Icons.school, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'О филиале "Кубанский Государственный Университет" в г. Геленджике:',
              style: TextStyle(
                fontSize: screenWidth < 400 ? 14.0 : 16.0,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'ComicSans',
              ),
              textAlign: TextAlign.left, // ВЕРНУЛИ НА left
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Text(
        'Филиал "Кубанский Государственный Университет" в г. Геленджике (КубГУ в г. Геленджике) — это современный филиал одного из ведущих вузов юга России, '
        'который сочетает академические традиции и инновационные подходы к образованию. '
        'Филиал готовит высококвалифицированных специалистов для наукоёмких отраслей экономики, '
        'внедряет передовые образовательные технологии и активно развивает научно-исследовательскую деятельность.',
        style: TextStyle(
          color: subTextColor,
          fontSize: normalFontSize,
          fontFamily: 'ComicSans',
          height: 1.5,
        ),
      ),
    ],
  ),
),
                  
                  const SizedBox(height: 20),
                  
                  // Команда разработчиков
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people_alt, color: Colors.green.shade700, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'От студентов КубГУ:',
                              style: TextStyle(
                                fontSize: screenWidth < 400 ? 14.0 : 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                                fontFamily: 'ComicSans',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTeamMember('Панов Максим Романович', 'Разработчик UI/UX, студент КубГУ', screenWidth),
                        const SizedBox(height: 8),
                        _buildTeamMember('Полежаев Дмитрий Дмитриевич', 'Ведущий разработчик, студент КубГУ', screenWidth),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Руководитель
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.purple.withOpacity(0.3), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.supervised_user_circle, color: Colors.purple.shade700, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Руководитель проекта:',
                              style: TextStyle(
                                fontSize: screenWidth < 400 ? 14.0 : 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade700,
                                fontFamily: 'ComicSans',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.person, color: Colors.purple.shade600, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Кривошеенко Татьяна Петровна',
                                    style: TextStyle(
                                      fontSize: screenWidth < 400 ? 13.0 : 15.0,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                      fontFamily: 'ComicSans',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Преподаватель Кубанского Государственного Университета в г. Геленджике, научный руководитель проекта',
                                    style: TextStyle(
                                      color: subTextColor,
                                      fontSize: screenWidth < 400 ? 11.0 : 13.0,
                                      fontFamily: 'ComicSans',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Контакты
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.mail, color: Colors.orange.shade700, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Контакты:',
                              style: TextStyle(
                                fontSize: screenWidth < 400 ? 14.0 : 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                                fontFamily: 'ComicSans',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.email_outlined, color: Colors.orange.shade600, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectableText(
                                'markotkh.guide@gmail.com',
                                style: TextStyle(
                                  color: Colors.orange.shade800,
                                  fontSize: screenWidth < 400 ? 13.0 : 15.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'ComicSans',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Официальная почта для связи по вопросам приложения',
                          style: TextStyle(
                            color: subTextColor,
                            fontSize: screenWidth < 400 ? 11.0 : 13.0,
                            fontFamily: 'ComicSans',
                            fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Кнопка закрытия
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade600, Colors.blue.shade800],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Закрыть',
                          style: TextStyle(
                            fontSize: screenWidth < 400 ? 14.0 : 16.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'ComicSans',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate(
          effects: [
            ScaleEffect(
              duration: 500.ms,
              curve: Curves.elasticOut,
              begin: Offset(0.8, 0.8),
              end: Offset(1.0, 1.0),
            ),
            FadeEffect(duration: 400.ms),
          ],
        );
      },
    );
  }

  Future<ImageInfo> _getImageInfo(ImageProvider imageProvider) async {
  final completer = Completer<ImageInfo>();
  final imageStream = imageProvider.resolve(ImageConfiguration.empty);
  
  final listener = ImageStreamListener((ImageInfo info, bool _) {
    if (!completer.isCompleted) {
      completer.complete(info);
    }
  });
  
  imageStream.addListener(listener);
  
  // Таймаут на случай, если изображение не загрузится
  Future.delayed(Duration(seconds: 5), () {
    if (!completer.isCompleted) {
      completer.completeError(TimeoutException('Image loading timeout'));
    }
  });
  
  try {
    return await completer.future;
  } finally {
    imageStream.removeListener(listener);
  }
}

  // Вспомогательный метод для отображения члена команды
  Widget _buildTeamMember(String name, String role, double screenWidth) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.grey.shade700;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_outline, size: 18, color: Colors.green.shade700),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: screenWidth < 400 ? 13.0 : 15.0,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'ComicSans',
                ),
              ),
              Text(
                role,
                style: TextStyle(
                  color: subTextColor,
                  fontSize: screenWidth < 400 ? 11.0 : 13.0,
                  fontFamily: 'ComicSans',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
Widget build(BuildContext context) {
  final textColor = _isDark ? Colors.white : Colors.black;
  final subTextColor = _isDark ? Colors.white70 : Colors.black87;
  return Scaffold(
    appBar: AppBar(
      title: const Text('Настройки', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'ComicSans')),
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.brightness_6, color: subTextColor),
            title: Text('Тема', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontFamily: 'ComicSans')),
            subtitle: Text(_isDark ? 'Тёмная' : 'Светлая', style: TextStyle(color: subTextColor, fontFamily: 'ComicSans')),
            trailing: Switch(value: _isDark, onChanged: _onThemeChanged, activeColor: Colors.green),
          ),
          CheckboxListTile(
            value: _savePhotos,
            onChanged: (value) => _onSavePhotosChanged(value!),
            title: Text('Сохранять фотографии, сделанные через камеру', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontFamily: 'ComicSans')),
            secondary: Icon(Icons.camera_alt, color: subTextColor),
          ),
          const SizedBox(height: 20),
          
          Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isDark 
                      ? [Colors.green.shade800, Colors.green.shade600]
                      : [Colors.green.shade700, Colors.green.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(_isDark ? 0.4 : 0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(140, 140),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.support_agent, size: 40),
                    SizedBox(height: 8),
                    Text(
                      "Поддержка", 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'ComicSans'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: FittedBox(
              child: ElevatedButton.icon(
                onPressed: () => _showHelpDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, 
                  foregroundColor: Colors.white, 
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                icon: const Icon(Icons.article_outlined, size: 30),
                label: const Text('Подробная справка по приложению', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'ComicSans')),
              ),
            ),
          ),
          const Spacer(),
          
          // Кнопка "О нас" овальная небольшая без иконки
          Center(
            child: GestureDetector(
              onTap: () => _showAboutDialog(context),
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isDark 
                        ? [Colors.blue.shade800, Colors.blue.shade600]
                        : [Colors.blue.shade600, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(_isDark ? 0.5 : 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'О нас',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicSans',
                      shadows: [
                        Shadow(
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate(
                effects: [
                  ScaleEffect(
                    duration: 800.ms,
                    curve: Curves.elasticOut,
                    begin: Offset(0.9, 0.9),
                    end: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Версия приложения
          Text(
            'Версия приложения: 1.1.1', 
            style: TextStyle(
              color: subTextColor, 
              fontSize: 14, 
              fontFamily: 'ComicSans',
              fontStyle: FontStyle.italic
            )
          ),
          
          const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// =============== ПОДДЕРЖКА ===============
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<File> _attachedImages = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_attachedImages.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Можно прикрепить не более 10 фотографий")),
      );
      return;
    }

    final int remaining = 10 - _attachedImages.length;

    // Для Windows используем стандартный выбор файлов
    if (Platform.isWindows) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      
      if (result != null && result.files.isNotEmpty) {
        final newImages = result.files
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .take(remaining)
            .toList();
            
        setState(() {
          _attachedImages.addAll(newImages);
        });

        if (_attachedImages.length >= 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Вы достигли лимита — максимум 10 фото")),
          );
        }
      }
    } else {
      // Для мобильных платформ используем WeChat Assets Picker
      final List<AssetEntity>? assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: remaining,
          requestType: RequestType.image,
          textDelegate: const RussianAssetPickerTextDelegate(),
          pathNameBuilder: (AssetPathEntity path) {
            if (path.isAll ||
                path.name.toLowerCase() == 'recent' ||
                path.name.toLowerCase() == 'recents' ||
                path.name.toLowerCase() == 'all') {
              return 'Недавние';
            }
            return path.name;
          },
        ),
      );

      if (assets != null && assets.isNotEmpty) {
        final List<File> newImages = [];
        for (var asset in assets) {
          final file = await asset.file;
          if (file != null) newImages.add(file);
        }

        setState(() {
          _attachedImages.addAll(newImages);
        });

        if (_attachedImages.length >= 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Вы достигли лимита — максимум 10 фото")),
          );
        }
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _attachedImages.removeAt(index);
    });
  }

  Future<void> _sendSupport() async {
  final messageText = _messageController.text.trim();
  if (messageText.isEmpty && _attachedImages.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Заполните сообщение или прикрепите хотя бы одно фото"))
    );
    return;
  }
  
  setState(() => _isSending = true);
  
  // Настройки Gmail
  final smtpServer = gmail('perozhizni.helper@gmail.com', 'blii goux nufu itcj');
  
  final emailMessage = Message()
    ..from = Address('perozhizni.helper@gmail.com')
    ..recipients.add('markotkh.guide@gmail.com')
    ..subject = 'Обращение в поддержку (Маркотх Гид)'
    ..text = '''
Пользователь отправил запрос в поддержку.
${messageText.isNotEmpty ? "Сообщение: $messageText" : "Сообщение не указано"}

Отправлено из приложения Маркотх Гид.
''';

  try {
    // Добавляем прикрепленные изображения
    for (int i = 0; i < _attachedImages.length; i++) {
      final image = _attachedImages[i];
      final compressed = await FlutterImageCompress.compressAndGetFile(
        image.path,
        '${image.parent.path}/support_${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
        quality: 70,
      );
      if (compressed != null) {
        emailMessage.attachments.add(
          FileAttachment(File(compressed.path))
            ..fileName = 'support_image_$i.jpg'
        );
      }
    }
    
    await send(emailMessage, smtpServer);
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Сообщение успешно отправлено"))
    );
    Navigator.pop(context);
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Ошибка отправки: $e"))
    );
  } finally {
    if (mounted) setState(() => _isSending = false);
  }
}

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isEmpty = _messageController.text.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Поддержка",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'ComicSans',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Если у вас есть вопросы или вы нашли баг в приложении — напишите нам.\n"
              "Вы можете приложить скриншоты или фото, чтобы мы быстрее разобрались.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontFamily: 'ComicSans'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _messageController,
              maxLines: 4,
              cursorColor: Colors.green,
              textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'ComicSans'),
              decoration: InputDecoration(
                hintText: isEmpty ? "Ваше сообщение" : null,
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.green[300]!.withOpacity(0.6) : Colors.green.withOpacity(0.6),
                  fontSize: 16,
                  fontFamily: 'ComicSans',
                ),
                labelText: isEmpty ? null : "Ваше сообщение",
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.green[300] : Colors.green,
                  fontSize: 16,
                  fontFamily: 'ComicSans',
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelAlignment: FloatingLabelAlignment.center,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 1.6),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: false,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                alignLabelWithHint: true,
              ),
              textAlignVertical: TextAlignVertical.center,
            ),

            const SizedBox(height: 12),

            if (_attachedImages.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _attachedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _attachedImages[index],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            const SizedBox(height: 12),

            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _isSending ? null : _pickImages,
                  icon: const Icon(Icons.photo),
                  label: const Text("Прикрепить фото", style: TextStyle(fontFamily: 'ComicSans')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.green.shade700 : Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _isSending ? null : _sendSupport,
                  icon: const Icon(Icons.send),
                  label: Text(_isSending ? "Отправка…" : "Отправить", style: TextStyle(fontFamily: 'ComicSans')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.green.shade700 : Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
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

// =============== ВСПОМОГАТЕЛЬНЫЙ ВИДЖЕТ ДЛЯ ПРЕДПРОСМОТРА ===============
class _MediaPreviewWidget extends StatefulWidget {
  final File file;
  final bool isVideo;
  final bool fillContainer; // Добавляем параметр
  
  const _MediaPreviewWidget({
    required this.file, 
    required this.isVideo,
    this.fillContainer = false, // По умолчанию false
  });
  
  @override
  State<_MediaPreviewWidget> createState() => _MediaPreviewWidgetState();
}

class _MediaPreviewWidgetState extends State<_MediaPreviewWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  
  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _initializeVideo();
    } else {
      _isInitialized = true;
    }
  }
  
  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.file(widget.file);
      await _controller!.initialize();
      await _controller!.setVolume(0.0);
      
      // Добавляем слушатель для обновления состояния
      _controller!.addListener(() {
        if (mounted) setState(() {});
      });
      
      setState(() {
        _isInitialized = true;
        _hasError = false;
      });
      
      await _controller!.pause();
      await _controller!.seekTo(Duration.zero);
      
    } catch (e) {
      print('Ошибка инициализации видео: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = true;
        });
      }
    }
  }
  
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
  
  @override
  void dispose() {
    if (_controller != null) {
      _controller!.removeListener(() {});
      _controller!.dispose();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Center(child: CircularProgressIndicator(color: Colors.green));
    }
    
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 10),
            const Text(
              'Не удалось загрузить видео',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'ComicSans',
              ),
            ),
          ],
        ),
      );
    }
    
    if (widget.isVideo && _controller != null) {
      return Stack(
        children: [
          // Видео с правильным заполнением без черных полос
          Container(
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),
          
          // Overlay для лучшей видимости кнопок
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
          ),
          
          // Кнопка Play/Pause
          Center(
            child: GestureDetector(
              onTap: () async {
                if (_controller!.value.isPlaying) {
                  await _controller!.pause();
                } else {
                  if (_controller!.value.position >= _controller!.value.duration) {
                    await _controller!.seekTo(Duration.zero);
                  }
                  await _controller!.play();
                }
                setState(() {});
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Icon(
                  _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          // Полоска прогресса внизу (зеленая)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.3),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final total = _controller!.value.duration;
                  final current = _controller!.value.position;
                  
                  double progress = 0;
                  if (total.inMilliseconds > 0) {
                    progress = current.inMilliseconds / total.inMilliseconds;
                    progress = progress.clamp(0.0, 1.0); // Ограничиваем значение от 0 до 1
                  }
                  
                  return Stack(
                    children: [
                      // Фон прогресса
                      Container(
                        width: constraints.maxWidth,
                        color: Colors.green.withOpacity(0.3),
                      ),
                      // Прогресс
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        width: constraints.maxWidth * progress,
                        color: Colors.green,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          
          // Время в правом нижнем углу
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${_formatDuration(_controller!.value.position)} / ${_formatDuration(_controller!.value.duration)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicSans',
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Для фото - используем BoxFit.cover для заполнения контейнера
      return Image.file(
        widget.file,
        fit: widget.fillContainer ? BoxFit.cover : BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(Icons.error, color: Colors.red, size: 50),
          );
        },
      );
    }
  }
}

// Вспомогательные методы:

class CompressionStrategy {
  final VideoQuality quality;
  final int frameRate;
  final bool includeAudio;
  final double targetDuration;
  final double maxTargetSize;
  final int maxSizeBeforeCompression;
  
  CompressionStrategy({
    required this.quality,
    required this.frameRate,
    required this.includeAudio,
    required this.targetDuration,
    required this.maxTargetSize,
    required this.maxSizeBeforeCompression,
  });
}

CompressionStrategy _determineCompressionStrategy({
  required int filesize,
  required double duration,
  required int resolution,
}) {
  // ignore: unused_local_variable
  final sizeMB = filesize / 1024 / 1024;
  
  // Определяем оптимальную длительность для анализа
  double targetDuration;
  if (duration <= 5) {
    targetDuration = duration; // Короткие видео оставляем как есть
  } else if (duration <= 15) {
    targetDuration = 10.0; // Средние видео обрезаем до 10 сек
  } else {
    targetDuration = 15.0; // Длинные видео обрезаем до 15 сек
  }
  
  // Определяем качество на основе разрешения и длительности
  VideoQuality quality;
  int frameRate;
  bool includeAudio;
  // ignore: unused_local_variable
  int? targetResolution;
  
  if (resolution > 1920 * 1080) { // Full HD и выше
    quality = VideoQuality.MediumQuality;
    frameRate = 24;
    includeAudio = false;
    targetResolution = 1920 * 1080; // Понижаем до Full HD
  } else if (resolution > 1280 * 720) { // HD и выше
    quality = VideoQuality.MediumQuality;
    frameRate = 24;
    includeAudio = true;
  } else {
    quality = VideoQuality.HighestQuality; // Для низких разрешений используем лучшее качество
    frameRate = 30;
    includeAudio = true;
  }
  
  // Корректируем для коротких видео
  if (duration < 3) {
    quality = VideoQuality.HighestQuality; // Для коротких видео максимальное качество
    frameRate = 30;
  }
  
  // Определяем максимальный целевой размер
  double maxTargetSize;
  if (duration < 5) {
    maxTargetSize = 3.0; // Короткие видео до 3 МБ
  } else if (duration < 10) {
    maxTargetSize = 5.0; // Средние видео до 5 МБ
  } else {
    maxTargetSize = 8.0; // Длинные видео до 8 МБ
  }
  
  // Определяем порог для сжатия
  int maxSizeBeforeCompression;
  if (duration < 5) {
    maxSizeBeforeCompression = 3 * 1024 * 1024; // 3 МБ
  } else {
    maxSizeBeforeCompression = 5 * 1024 * 1024; // 5 МБ
  }
  
  return CompressionStrategy(
    quality: quality,
    frameRate: frameRate,
    includeAudio: includeAudio,
    targetDuration: targetDuration,
    maxTargetSize: maxTargetSize,
    maxSizeBeforeCompression: maxSizeBeforeCompression,
  );
}

Future<File?> _compressWithHighQuality(File video) async {
  try {
    print('🎯 Применяю высококачественное сжатие для короткого видео');
    
    final compressed = await VideoCompress.compressVideo(
      video.path,
      quality: VideoQuality.HighestQuality,
      deleteOrigin: false,
      includeAudio: true,
      frameRate: 30,
    );
    
    return compressed?.file;
  } catch (e) {
    print('❌ Ошибка высококачественного сжатия: $e');
    return null;
  }
}

Future<File?> _tryAlternativeCompression(File video, CompressionStrategy strategy) async {
  try {
    print('🔄 Пробую альтернативные параметры сжатия');
    
    // Пробуем сжатие без обрезки
    final compressed = await VideoCompress.compressVideo(
      video.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: false,
      frameRate: 20,
    );
    
    if (compressed != null && compressed.file != null) {
      final size = compressed.file!.lengthSync() / 1024 / 1024;
      print('📉 Альтернативное сжатие: ${size.toStringAsFixed(2)} MB');
      return compressed.file;
    }
    
    // Последняя попытка - минимальное сжатие
    final lastTry = await VideoCompress.compressVideo(
      video.path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false,
      includeAudio: false,
      frameRate: 15,
    );
    
    return lastTry?.file;
  } catch (e) {
    print('❌ Альтернативное сжатие не удалось: $e');
    return null;
  }
}

Future<File?> _applyAdditionalOptimization(File video, CompressionStrategy strategy) async {
  try {
    print('⚙️ Применяю дополнительную оптимизацию');
    
    final recompressed = await VideoCompress.compressVideo(
      video.path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false,
      includeAudio: false,
      frameRate: strategy.frameRate - 5,
    );
    
    if (recompressed != null && recompressed.file != null) {
      final size = recompressed.file!.lengthSync() / 1024 / 1024;
      print('📉 После дополнительной оптимизации: ${size.toStringAsFixed(2)} MB');
      
      if (size > strategy.maxTargetSize * 1.5) {
        print('⚠️ Видео все еще слишком большое для отправки');
        return null;
      }
      
      return recompressed.file;
    }
    
    return null;
  } catch (e) {
    print('❌ Дополнительная оптимизация не удалась: $e');
    return null;
  }
}

Future<File?> _compressWithBetterQuality(File video) async {
  try {
    print('✨ Повышаю качество сжатия');
    
    final compressed = await VideoCompress.compressVideo(
      video.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
      frameRate: 24,
    );
    
    return compressed?.file;
  } catch (e) {
    print('❌ Не удалось повысить качество: $e');
    return null;
  }
}

Future<File?> _fallbackToOriginal(File video) async {
  try {
    final fileSize = await video.length();
    final sizeMB = fileSize / 1024 / 1024;
    
    if (sizeMB < 10.0) {
      print('⚠️ Возвращаю оригинальное видео (${sizeMB.toStringAsFixed(2)} MB)');
      return video;
    }
    
    print('❌ Оригинальное видео слишком большое (${sizeMB.toStringAsFixed(2)} MB)');
    return null;
  } catch (_) {
    print('❌ Не удалось проверить размер файла');
    return null;
  }
}

// Отдельный StatefulWidget для полноэкранного видео
class FullScreenVideoDialog extends StatefulWidget {
  final File videoFile;
  
  const FullScreenVideoDialog({Key? key, required this.videoFile}) : super(key: key);
  
  @override
  State<FullScreenVideoDialog> createState() => _FullScreenVideoDialogState();
}

class _FullScreenVideoDialogState extends State<FullScreenVideoDialog> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isPlaying = false;
  
  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }
  
  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.file(widget.videoFile);
      await _controller.initialize();
      
      // Добавляем слушатель для обновления состояния
      _controller.addListener(_updateState);
      
      // Ставим видео на паузу в начале
      await _controller.pause();
      await _controller.seekTo(Duration.zero);
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isPlaying = false;
        });
      }
      
    } catch (e) {
      print('❌ Ошибка инициализации видео: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = true;
        });
      }
    }
  }
  
  void _updateState() {
    if (mounted) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    }
  }
  
  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = _controller.value.isPlaying;
    });
  }
  
  void _onSliderChanged(double value) {
    final newPosition = Duration(milliseconds: value.toInt());
    
    // При начале перетаскивания ставим на паузу
    if (_controller.value.isPlaying) {
      _controller.pause();
    }
    
    _controller.seekTo(newPosition);
    
    // Если видео было на паузе, оставляем на паузе
    // Если играло, продолжаем после завершения перетаскивания
    // (это обрабатывается в _onSliderChangeEnd)
  }
  
  void _onSliderChangeEnd(double value) {
    // После перетаскивания, если видео играло - продолжаем
    if (!_controller.value.isPlaying && _isPlaying) {
      _controller.play();
    }
  }
  
  @override
  void dispose() {
    _controller.removeListener(_updateState);
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: !_isInitialized
            ? Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
            : _hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 50),
                        SizedBox(height: 16),
                        Text(
                          'Ошибка загрузки видео',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'ComicSans',
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Закрыть', style: TextStyle(fontFamily: 'ComicSans')),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      // Видео
                      Center(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                      
                      // Надпись ВИДЕО вверху слева
                      Positioned(
                        top: 40,
                        left: 20,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.videocam, size: 16, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'ВИДЕО',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ComicSans',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Кнопка закрытия вверху справа
                      Positioned(
                        top: 30,
                        right: 20,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.white, size: 30),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      
                      // Кнопка Play/Pause по центру
                      Positioned.fill(
                        child: Center(
                          child: GestureDetector(
                            onTap: _togglePlayPause,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Прогресс бар внизу
                      Positioned(
                        bottom: 30,
                        left: 20,
                        right: 20,
                        child: Column(
                          children: [
                            // Ползунок прогресса
                            Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: _controller.value.position.inMilliseconds.toDouble(),
                                    min: 0,
                                    max: _controller.value.duration.inMilliseconds.toDouble(),
                                    onChanged: _onSliderChanged,
                                    onChangeStart: (value) {
                                      // При начале перетаскивания запоминаем состояние
                                      if (_controller.value.isPlaying) {
                                        _controller.pause();
                                      }
                                    },
                                    onChangeEnd: _onSliderChangeEnd,
                                    activeColor: Colors.green,
                                    inactiveColor: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            
                            // Время
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(_controller.value.position),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'ComicSans',
                                    ),
                                  ),
                                  Text(
                                    _formatDuration(_controller.value.duration),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'ComicSans',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}