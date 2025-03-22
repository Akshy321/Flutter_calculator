import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
      } else if (value == '=') {
        try {
          _result = _evaluateExpression(_expression);
        } catch (e) {
          _result = 'Error';
        }
      } else {
        _expression += value;
      }
    });
  }

  String _evaluateExpression(String expression) {
    try {
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      return _calculate(expression).toString();
    } catch (e) {
      return 'Error';
    }
  }

  double _calculate(String expression) {
    List<String> tokens = expression.split(RegExp(r'([+\-*/])'));
    List<double> numbers = [];
    List<String> operators = [];

    for (var token in tokens) {
      if (RegExp(r'^[0-9.]+$').hasMatch(token)) {
        numbers.add(double.parse(token));
      } else {
        operators.add(token);
      }
    }

    while (operators.isNotEmpty) {
      double num1 = numbers.removeAt(0);
      double num2 = numbers.removeAt(0);
      String op = operators.removeAt(0);
      double result = _performOperation(num1, num2, op);
      numbers.insert(0, result);
    }
    return numbers.first;
  }

  double _performOperation(double num1, double num2, String op) {
    switch (op) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '*':
        return num1 * num2;
      case '/':
        return num2 != 0 ? num1 / num2 : double.infinity;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Wrap(
            children: [
              ...['7', '8', '9', '/'],
              ...['4', '5', '6', '*'],
              ...['1', '2', '3', '-'],
              ...['C', '0', '=', '+'],
            ].map((text) => _buildButton(text)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return SizedBox(
      width: 90,
      height: 90,
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(text),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
