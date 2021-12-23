import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/ui/weather_viewmodel.dart';

class AutocompleteAppBar extends StatefulWidget {
  const AutocompleteAppBar({Key? key}) : super(key: key);

  static final List<City> _kOptions = <City>[
    const City(name: 'Your location', latitude: 0, longitude: 0),
    const City(name: 'New York', latitude: 40.709420, longitude: -73.912453),
    const City(name: 'Sydney', latitude: -33.876441, longitude: 151.205199),
    const City(name: 'Hong Kong', latitude: 22.316144, longitude: 114.182228),
    const City(name: 'Tokyo', latitude: 35.679244, longitude: 139.764631),
    const City(name: 'Berlin', latitude: 52.514024, longitude: 13.399422),
    const City(
        name: 'Cape Town City', latitude: -33.925814, longitude: 18.419792),
  ];

  @override
  _AutocompleteAppBarState createState() => _AutocompleteAppBarState();
}

class _AutocompleteAppBarState extends State<AutocompleteAppBar> {
  late FocusNode _focusNode;
  bool _shouldClear = false;

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Autocomplete<City>(
        //вернет объекты, основываясь на TextEditingValue
        optionsBuilder: (TextEditingValue textEditingValue) {
          List<City> returned = [];
          if (textEditingValue.text == '') {
            returned.add(AutocompleteAppBar._kOptions.first);
          } else {
            returned = AutocompleteAppBar._kOptions;
          }
          return returned;
        },
        //поле, в которое пользователь вводит текст для поиска
        fieldViewBuilder: (BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          _focusNode = focusNode;
          _focusNode.addListener(_onOnFocusNodeEvent);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: _getColor(_focusNode),
              borderRadius: _getBorder(_focusNode),
            ),
            child: TextField(
              controller: fieldTextEditingController,
              focusNode: _focusNode,
              onTap: () => {
                if (_shouldClear) fieldTextEditingController.clear(),
                _shouldClear = false,
              },
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                suffixIcon: SuffixIconWidget(),
                border: InputBorder.none,
                hintText: "Search...",
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          );
        },
        //создает выбираемые объекты
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<City> onSelected, Iterable<City> options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 100),
              child: Material(
                color: Colors.white,
                shadowColor: Colors.black,
                elevation: 5,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  width: constraints.biggest.width,
                  //height: constraints.biggest.height,
                  child: ListView.builder(
                    // padding: EdgeInsets.all(10.0),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final City option = options.elementAt(index);

                      return Container(
                        // color: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 7),
                        child: GestureDetector(
                          onTap: () {
                            onSelected(option);
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on),
                                  const SizedBox(width: 15),
                                  Text(
                                    option.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.grey, height: 3)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
        //возвращает строку выбранной опции, которая подставляется в поле ввода текста
        displayStringForOption: (City option) => option.name,
        onSelected: (City selection) {
          _focusNode.unfocus();
          _shouldClear = true;
          if (selection != AutocompleteAppBar._kOptions[0]) {
            Provider.of<WeatherViewModel>(context, listen: false)
                .getWeatherSearchtLocation(
                    selection.latitude, selection.longitude);
          }
          print('You just selected ${selection.name}');
        },
      ),
    );
  }

  BorderRadius _getBorder(FocusNode _focusNode) {
    return _focusNode.hasFocus
        ? const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25))
        : const BorderRadius.all(Radius.circular(25));
  }

  Color _getColor(FocusNode _focusNode) {
    return _focusNode.hasFocus ? Colors.white : Colors.white.withOpacity(0.5);
  }
}

class SuffixIconWidget extends StatelessWidget {
  const SuffixIconWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WeatherViewModel>(context);
    return model.isLoading
        ? const SizedBox(
            height: 5,
            width: 5,
            child: Center(child: CircularProgressIndicator()))
        : IconButton(
            onPressed: () => {
              model.getWeatherCurrentLocation(),
              // if (!model.isFirstLoad)
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //     content: Text(model.errorMessage, style: const TextStyle(color: Colors.black)),
              //     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              //     backgroundColor: Colors.white,
              //     behavior: SnackBarBehavior.floating,
              //     margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              //     duration: const Duration(seconds: 1),
              //   )),
            },
            icon: const Icon(Icons.location_on),
          );
  }
}

class City {
  const City({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;
}
