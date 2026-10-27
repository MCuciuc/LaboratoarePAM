import 'package:flutter/material.dart';

void main() {
  runApp(const SalaryCalculatorApp());
}

class SalaryCalculatorApp extends StatelessWidget {
  const SalaryCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator Salariu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SalaryCalculatorScreen(),
    );
  }
}

enum EmployeeType {
  standard('Standard (Impozit 10%)', 0.10),
  it('IT / Scutit de impozit (0%)', 0.00),
  reduced('Cota redusă (5%)', 0.05);

  final String label;
  final double taxRate;
  const EmployeeType(this.label, this.taxRate);
}

class SalaryCalculatorScreen extends StatefulWidget {
  const SalaryCalculatorScreen({super.key});

  @override
  State<SalaryCalculatorScreen> createState() => _SalaryCalculatorScreenState();
}

class _SalaryCalculatorScreenState extends State<SalaryCalculatorScreen> {
  final TextEditingController _grossSalaryController = TextEditingController();
  EmployeeType _selectedType = EmployeeType.standard;

  double? _netSalary;
  double? _taxAmount;

  void _calculateSalary() {
    final double? gross = double.tryParse(_grossSalaryController.text);

    setState(() {
      if (gross != null && gross >= 0) {
        _taxAmount = gross * _selectedType.taxRate;
        _netSalary = gross - _taxAmount!;
      } else {
        _taxAmount = null;
        _netSalary = null;
      }
    });
  }

  @override
  void dispose() {
    _grossSalaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laborator 1 - Calculator Salariu'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextField(
                controller: _grossSalaryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Salariu Brut',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Selectează tipul de angajat / impozitare:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Column(
                children: EmployeeType.values.map((type) {
                  return RadioListTile<EmployeeType>(
                    title: Text(type.label),
                    value: type,
                    groupValue: _selectedType,
                    onChanged: (EmployeeType? value) {
                      if (value != null) {
                        setState(() {
                          _selectedType = value;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),


              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _calculateSalary,
                  child: const Text('Calculează', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 24),


              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rezultate:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      if (_netSalary != null && _taxAmount != null) ...[
                        Text(
                          'Suma impozitului: ${_taxAmount!.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Salariu Net: ${_netSalary!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ] else ...[
                        const Text(
                          'Introdu un salariu brut valid și apasă pe butonul "Calculează".',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}