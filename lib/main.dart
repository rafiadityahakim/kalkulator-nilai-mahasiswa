import 'package:flutter/material.dart';

void main() {
  runApp(const KalkulatorNilaiApp());
}

class KalkulatorNilaiApp extends StatelessWidget {
  const KalkulatorNilaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Nilai Mahasiswa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DaftarMahasiswaPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Model Data Mahasiswa
class Student {
  final String nama;
  final double tugas;
  final double uts;
  final double uas;
  late final double nilaiAkhir;
  late final String status;
  late final String grade;

  Student({
    required this.nama,
    required this.tugas,
    required this.uts,
    required this.uas,
  }) {
    // Perhitungan Nilai Akhir sesuai ketentuan
    nilaiAkhir = (tugas * 0.3) + (uts * 0.3) + (uas * 0.4);
    status = nilaiAkhir >= 60 ? 'Lulus' : 'Tidak Lulus';
    grade = _calculateGrade(nilaiAkhir);
  }

  String _calculateGrade(double nilai) {
    if (nilai >= 85) return 'A';
    if (nilai >= 75) return 'B';
    if (nilai >= 65) return 'C';
    if (nilai >= 50) return 'D';
    return 'E';
  }
}

class DaftarMahasiswaPage extends StatefulWidget {
  const DaftarMahasiswaPage({super.key});

  @override
  State<DaftarMahasiswaPage> createState() => _DaftarMahasiswaPageState();
}

class _DaftarMahasiswaPageState extends State<DaftarMahasiswaPage> {
  // Daftar awal memuat minimal 10 mahasiswa sesuai instruksi
  final List<Student> _studentList = [
    Student(nama: 'Andi Pratama', tugas: 85, uts: 80, uas: 90),
    Student(nama: 'Budi Santoso', tugas: 70, uts: 65, uas: 75),
    Student(nama: 'Citra Dewi', tugas: 90, uts: 85, uas: 88),
    Student(nama: 'Dedi Kurniawan', tugas: 55, uts: 60, uas: 58),
    Student(nama: 'Eka Lestari', tugas: 40, uts: 45, uas: 50),
    Student(nama: 'Fajar Hidayat', tugas: 80, uts: 75, uas: 82),
    Student(nama: 'Gita Permata', tugas: 95, uts: 90, uas: 92),
    Student(nama: 'Hadi Wijaya', tugas: 60, uts: 55, uas: 65),
    Student(nama: 'Indah Puspa', tugas: 75, uts: 80, uas: 78),
    Student(nama: 'Joko Susilo', tugas: 50, uts: 50, uas: 45), // Diperbaiki parameter constructor
  ];

  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _tugasController = TextEditingController();
  final _utsController = TextEditingController();
  final _uasController = TextEditingController();

  void _tambahMahasiswa() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _studentList.add(
          Student(
            nama: _namaController.text,
            tugas: double.parse(_tugasController.text),
            uts: double.parse(_utsController.text),
            uas: double.parse(_uasController.text),
          ),
        );
      });
      _namaController.clear();
      _tugasController.clear();
      _utsController.clear();
      _uasController.clear();
      Navigator.pop(context);
    }
  }

  void _showFormDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Mahasiswa'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(labelText: 'Nama Mahasiswa'),
                    validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  TextFormField(
                    controller: _tugasController,
                    decoration: const InputDecoration(labelText: 'Nilai Tugas (0-100)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) return 'Nilai tugas wajib diisi';
                      if (double.tryParse(value) == null) return 'Masukkan angka valid';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _utsController,
                    decoration: const InputDecoration(labelText: 'Nilai UTS (0-100)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) return 'Nilai UTS wajib diisi';
                      if (double.tryParse(value) == null) return 'Masukkan angka valid';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _uasController,
                    decoration: const InputDecoration(labelText: 'Nilai UAS (0-100)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) return 'Nilai UAS wajib diisi';
                      if (double.tryParse(value) == null) return 'Masukkan angka valid';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: _tambahMahasiswa,
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Nilai Mahasiswa'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: _studentList.length,
        itemBuilder: (context, index) {
          final student = _studentList[index];
          final isLulus = student.status == 'Lulus';
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 3,
            child: ListTile(
              title: Text(
                student.nama,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Tugas: ${student.tugas} | UTS: ${student.uts} | UAS: ${student.uas}\n'
                'Nilai Akhir: ${student.nilaiAkhir.toStringAsFixed(2)} | Grade: ${student.grade}',
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isLulus ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  student.status,
                  style: TextStyle(
                    color: isLulus ? Colors.green.shade800 : Colors.red.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}