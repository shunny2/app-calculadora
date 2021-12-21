class Memory {

  static const operations = ['%', '/', 'x', '-', '+', '='];

  final _buffer = [0.0, 0.0];
  int _bufferIndex = 0;
  bool _wipeValue = false;
  String _operation;
  String _value = '0';
  String _lastCommand;

  void applyCommand(String command) {
    if(_isReplacingOperation(command)) {
      _operation = command; //substitui a operação e retorna
      return;
    }

    if (command == 'AC') {
      return _allClear();
    } else if (operations.contains(command)) {
      _setOperation(command);
    }else {
      _addDigit(command);
    }
    _lastCommand = command;
  }

  _isReplacingOperation(String command) { 
    return operations.contains(_lastCommand)
      && operations.contains(command)
      && _lastCommand != '='
      && command != '=';
      //se ele for diferente de igual e os comandos estiverem contido. ele ta trocando de operação.
  }

  _setOperation(String newOperation) {
    bool isEqualSign = newOperation == '=';
    if(_bufferIndex == 0) {
      if(!isEqualSign) {
        _operation = newOperation;
        _bufferIndex = 1;
        _wipeValue = true;
      }
    }else {
      _buffer[0] = _calculate();
      _buffer[1] = 0.0;
      _value = _buffer[0].toString();
      _value = _value.endsWith('.0') ? _value.split('.')[0] : _value; //se o valor terminar com .0 então vou cortar e mostrar a primeira parte se n exibo o valor.
      
      _operation = isEqualSign ? null : newOperation; //começa uma nova operação
      _bufferIndex = isEqualSign ? 0 : 1;
    }
    _wipeValue = true; //!isEqualSign;
  }

  _addDigit(String digit) {
    final isDot = digit == '.';
    final wipeValue = (_value == '0' && !isDot) || _wipeValue; //se o valor for 0 ou wipevalue for verdadeiro. ele terá que limpar a tela.
    
    if(isDot && _value.contains('.') && !wipeValue) { //se for ponto e ja conter algum ponto
      return;
    }

    final emptyValue = isDot ? '0' : '';
    final currentValue = wipeValue ? emptyValue : _value;
    _value = currentValue + digit;
    _wipeValue = false;

    _buffer[_bufferIndex] = double.tryParse(_value) ?? 0; //Converte string para double.Caso nao faça o parse ele vai usar o valor padrão 0.

  }

  _calculate() {
    switch(_operation) {
      case '%': return _buffer[0] % _buffer[1];
      case '/': return _buffer[0] / _buffer[1];
      case 'x': return _buffer[0] * _buffer[1];
      case '-': return _buffer[0] - _buffer[1];
      case '+': return _buffer[0] + _buffer[1];
      default: return _buffer[0];
    }
  }

  void _allClear() {
    _value = '0';
    _buffer.setAll(0, [0.0, 0.0]);
    _operation = null;
    _bufferIndex = 0;
    _wipeValue = false;
  }

  String get value {
    return _value;
  }
}