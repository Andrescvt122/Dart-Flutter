import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KajaMartMobileApp());
}

class KajaMartMobileApp extends StatelessWidget {
  const KajaMartMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KajaMart Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        useMaterial3: true,
      ),
      home: const AppBootstrapper(),
    );
  }
}

class AppBootstrapper extends StatefulWidget {
  const AppBootstrapper({super.key});

  @override
  State<AppBootstrapper> createState() => _AppBootstrapperState();
}

class _AppBootstrapperState extends State<AppBootstrapper> {
  Future<AuthSession?>? _sessionFuture;

  @override
  void initState() {
    super.initState();
    _sessionFuture = SessionStorage.readSession();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const RestrictedPlatformScreen();
    }

    return FutureBuilder<AuthSession?>(
      future: _sessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data;
        if (session == null) {
          return LoginPage(
            onLogin: (newSession) {
              setState(() {
                _sessionFuture = Future.value(newSession);
              });
            },
          );
        }

        return HomePage(
          session: session,
          onLogout: () async {
            await SessionStorage.clear();
            if (mounted) {
              setState(() {
                _sessionFuture = Future.value(null);
              });
            }
          },
          onSessionUpdated: (updatedSession) {
            setState(() {
              _sessionFuture = Future.value(updatedSession);
            });
          },
        );
      },
    );
  }
}

class RestrictedPlatformScreen extends StatelessWidget {
  const RestrictedPlatformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Esta experiencia está disponible únicamente para mobile.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLogin});

  final ValueChanged<AuthSession> onLogin;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final login = await ApiService.login(email: email, password: password);
      final tokenPayload = JwtUtils.decodePayload(login.token);
      final rolId = tokenPayload['rol_id'];
      final userId = tokenPayload['uid'];

      if (rolId is! int || userId is! int) {
        throw const FormatException('Token JWT inválido');
      }

      final role = await ApiService.getRoleById(rolId);
      final permissions = role.permissions;

      final session = AuthSession(
        token: login.token,
        userId: userId,
        roleId: rolId,
        permissions: permissions,
      );

      await SessionStorage.saveSession(session);
      widget.onLogin(session);
    } on AuthException {
      setState(() {
        _error = 'Correo o contraseñas incorrectas';
      });
    } catch (_) {
      setState(() {
        _error = 'No fue posible iniciar sesión. Intenta nuevamente.';
      });
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(Icons.storefront, size: 56),
                          const SizedBox(height: 12),
                          Text(
                            'Bienvenido a KajaMart',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Correo',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Ingresa el correo';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa la contraseña';
                              }
                              return null;
                            },
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: _isLoading ? null : _submit,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.login),
                            label: const Text('Iniciar sesión'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.session,
    required this.onLogout,
    required this.onSessionUpdated,
  });

  final AuthSession session;
  final Future<void> Function() onLogout;
  final ValueChanged<AuthSession> onSessionUpdated;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthSession _session;
  late List<_NavItem> _visibleItems;
  int _currentIndex = 0;

  static const Map<String, _NavItem> _permissionToItem = {
    'Ver clientes': _NavItem('Clientes', Icons.groups_2_outlined),
    'Ver compras': _NavItem('Compras', Icons.shopping_cart_checkout),
    'Ver ventas': _NavItem('Ventas', Icons.point_of_sale),
    'Ver categorias': _NavItem('Categorías', Icons.category_outlined),
    'Ver productos': _NavItem('Productos', Icons.inventory_2_outlined),
    'Ver proveedores': _NavItem('Proveedores', Icons.local_shipping_outlined),
  };

  @override
  void initState() {
    super.initState();
    _session = widget.session;
    _visibleItems = _buildVisibleItems(_session.permissions);
  }

  List<_NavItem> _buildVisibleItems(List<String> permissions) {
    final normalized = permissions
        .map((permission) => permission.trim().toLowerCase())
        .toSet();

    final List<_NavItem> items = [];
    _permissionToItem.forEach((permission, item) {
      if (normalized.contains(permission.toLowerCase())) {
        items.add(item);
      }
    });

    return items;
  }

  Future<void> _refreshPermissions() async {
    final role = await ApiService.getRoleById(_session.roleId);
    final updatedSession = _session.copyWith(permissions: role.permissions);
    await SessionStorage.saveSession(updatedSession);
    widget.onSessionUpdated(updatedSession);

    if (mounted) {
      setState(() {
        _session = updatedSession;
        _visibleItems = _buildVisibleItems(updatedSession.permissions);
        if (_currentIndex >= _visibleItems.length) {
          _currentIndex = 0;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = _visibleItems.isEmpty ? null : _visibleItems[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedItem?.label ?? 'KajaMart Mobile'),
        actions: [
          IconButton(
            tooltip: 'Actualizar permisos',
            onPressed: _refreshPermissions,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Mi perfil',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProfilePage(token: _session.token, userId: _session.userId),
                ),
              );
            },
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: selectedItem == null
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No tienes permisos de visualización para los módulos configurados.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : _ModulePanel(moduleName: selectedItem.label),
      bottomNavigationBar: _visibleItems.isEmpty
          ? null
          : NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: _visibleItems
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.icon),
                      label: item.label,
                    ),
                  )
                  .toList(),
            ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              const ListTile(
                leading: Icon(Icons.verified_user_outlined),
                title: Text('Permisos habilitados'),
              ),
              ..._visibleItems.map(
                (item) => ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.label),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              ),
              if (_visibleItems.isEmpty)
                const ListTile(
                  title: Text('Sin permisos de visualización disponibles.'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.token, required this.userId});

  final String token;
  final int userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: FutureBuilder<UserProfile>(
        future: ApiService.getUserById(userId, token: token),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('No fue posible cargar tu perfil.'),
              ),
            );
          }

          final profile = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${profile.nombre} ${profile.apellido}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text('Documento: ${profile.documento}'),
                      Text('Teléfono: ${profile.telefono}'),
                      Text('Correo: ${profile.email}'),
                      Text('Rol: ${profile.rolNombre.trim()}'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ModulePanel extends StatelessWidget {
  const _ModulePanel({required this.moduleName});

  final String moduleName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, size: 44, color: Colors.green),
              const SizedBox(height: 10),
              Text(
                'Módulo habilitado',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                moduleName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

class AuthSession {
  const AuthSession({
    required this.token,
    required this.userId,
    required this.roleId,
    required this.permissions,
  });

  final String token;
  final int userId;
  final int roleId;
  final List<String> permissions;

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'roleId': roleId,
      'permissions': permissions,
    };
  }

  factory AuthSession.fromJson(Map<String, dynamic> map) {
    return AuthSession(
      token: map['token'] as String,
      userId: map['userId'] as int,
      roleId: map['roleId'] as int,
      permissions: (map['permissions'] as List<dynamic>).cast<String>(),
    );
  }

  AuthSession copyWith({List<String>? permissions}) {
    return AuthSession(
      token: token,
      userId: userId,
      roleId: roleId,
      permissions: permissions ?? this.permissions,
    );
  }
}

class LoginResult {
  const LoginResult(this.token);

  final String token;
}

class RoleResult {
  const RoleResult(this.permissions);

  final List<String> permissions;
}

class UserProfile {
  const UserProfile({
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.documento,
    required this.email,
    required this.rolNombre,
  });

  final String nombre;
  final String apellido;
  final String telefono;
  final String documento;
  final String email;
  final String rolNombre;
}

class AuthException implements Exception {
  const AuthException();
}

class ApiService {
  static const _baseUrl = 'http://localhost:3000/kajamart/api';

  static Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final Map<String, dynamic> data = _decodeMap(response.body);
    if (response.statusCode >= 400 || data['token'] == null) {
      throw const AuthException();
    }

    return LoginResult(data['token'] as String);
  }

  static Future<RoleResult> getRoleById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/roles/$id'));
    final Map<String, dynamic> data = _decodeMap(response.body);
    final permisos = (data['rol_permisos'] as List<dynamic>? ?? [])
        .map((entry) => (entry['permisos']?['permiso_nombre'] ?? '') as String)
        .where((name) => name.trim().isNotEmpty)
        .toList();

    return RoleResult(permisos);
  }

  static Future<UserProfile> getUserById(int id, {required String token}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final Map<String, dynamic> data = _decodeMap(response.body);

    return UserProfile(
      nombre: '${data['nombre'] ?? ''}'.trim(),
      apellido: '${data['apellido'] ?? ''}'.trim(),
      telefono: '${data['telefono'] ?? ''}'.trim(),
      documento: '${data['documento'] ?? ''}'.trim(),
      email: '${data['acceso']?['email'] ?? ''}'.trim(),
      rolNombre: '${data['acceso']?['roles']?['rol_nombre'] ?? ''}'.trim(),
    );
  }

  static Map<String, dynamic> _decodeMap(String body) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return <String, dynamic>{};
  }
}

class SessionStorage {
  static const _sessionKey = 'auth_session';

  static Future<void> saveSession(AuthSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(session.toJson()));
  }

  static Future<AuthSession?> readSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionKey);
    if (raw == null) return null;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return AuthSession.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}

class JwtUtils {
  static Map<String, dynamic> decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('JWT mal formado');
    }

    final normalized = base64Url.normalize(parts[1]);
    final payload = utf8.decode(base64Url.decode(normalized));
    final decoded = jsonDecode(payload);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Payload inválido');
    }

    return decoded;
  }
}
