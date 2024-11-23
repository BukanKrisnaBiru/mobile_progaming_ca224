import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Tumbuhan',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: PlantListPage(),
    );
  }
}

class Plant {
  String speciesName;
  String indonesianName;
  String description;
  String imageUrl;

  Plant({
    required this.speciesName,
    required this.indonesianName,
    required this.description,
    required this.imageUrl,
  });
}

class PlantListPage extends StatefulWidget {
  const PlantListPage({super.key});

  @override
  _PlantListPageState createState() => _PlantListPageState();
}

class _PlantListPageState extends State<PlantListPage> {
  List<Plant> plants = [
    Plant(
      speciesName: 'Monstera deliciosa',
      indonesianName: 'kayu manis',
      description: 'Tumbuhan hias populer dengan daun berlubang.',
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  void _addPlant(Plant plant) {
    setState(() {
      plants.add(plant);
    });
  }

  void _updatePlant(int index, Plant updatedPlant) {
    setState(() {
      plants[index] = updatedPlant;
    });
  }

  void _deletePlant(int index) {
    setState(() {
      plants.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Tumbuhan'),
      ),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          return Card(
            child: ListTile(
              leading: Image.network(
                plant.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(plant.indonesianName),
              subtitle: Text(plant.speciesName),
              onTap: () async {
                final updatedPlant = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlantFormPage(
                      plant: plant,
                    ),
                  ),
                );
                if (updatedPlant != null) {
                  _updatePlant(index, updatedPlant);
                }
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deletePlant(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newPlant = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantFormPage(),
            ),
          );
          if (newPlant != null) {
            _addPlant(newPlant);
          }
        },
      ),
    );
  }
}

class PlantFormPage extends StatefulWidget {
  final Plant? plant;

  const PlantFormPage({super.key, this.plant});

  @override
  _PlantFormPageState createState() => _PlantFormPageState();
}

class _PlantFormPageState extends State<PlantFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _speciesNameController;
  late TextEditingController _indonesianNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _speciesNameController = TextEditingController(
      text: widget.plant?.speciesName ?? '',
    );
    _indonesianNameController = TextEditingController(
      text: widget.plant?.indonesianName ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.plant?.description ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.plant?.imageUrl ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant == null
            ? 'Tambah Data Tumbuhan'
            : 'Edit Data Tumbuhan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _speciesNameController,
                decoration: const InputDecoration(labelText: 'Nama Spesies'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama spesies harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _indonesianNameController,
                decoration: const InputDecoration(labelText: 'Nama Indonesia'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Indonesia harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'URL Gambar'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'URL gambar harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final plant = Plant(
                      speciesName: _speciesNameController.text,
                      indonesianName: _indonesianNameController.text,
                      description: _descriptionController.text,
                      imageUrl: _imageUrlController.text,
                    );
                    Navigator.pop(context, plant);
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
