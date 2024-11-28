import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../service/auth_service.dart';
import '../viewmodel/settings_viewmodel.dart';
import 'component/navbar.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key, required String username});

  @override
  State<SettingsView> createState() => _SettingsView();
}

class _SettingsView extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: viewModel.load(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black45,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                TextEditingController firstNameController =
                                    TextEditingController();
                                TextEditingController lastNameController =
                                    TextEditingController();
                                return AlertDialog(
                                  title: const Text('Set your name'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextField(
                                        controller: firstNameController,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your first name',
                                        ),
                                      ),
                                      TextField(
                                        controller: lastNameController,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your last name',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        String firstName =
                                            firstNameController.text;
                                        String lastName =
                                            lastNameController.text;
                                        if (firstName.isNotEmpty &&
                                            lastName.isNotEmpty) {
                                          viewModel.setFirstName(firstName);
                                          viewModel.setLastName(lastName);
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              '${viewModel.firstName} ${viewModel.lastName}',
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.fontSize,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      TextEditingController weightController =
                                          TextEditingController();
                                      return AlertDialog(
                                        title: const Text('Set your weight'),
                                        content: TextField(
                                          controller: weightController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText:
                                                'Enter your weight in pounds',
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              double? newWeight =
                                                  double.tryParse(
                                                      weightController.text);
                                              if (newWeight != null) {
                                                viewModel.setWeightInPounds(
                                                    newWeight);
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                  child: Text(
                                    'Weight: ${viewModel.weightInPounds}lbs',
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.fontSize,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      TextEditingController heightController =
                                          TextEditingController();
                                      return AlertDialog(
                                        title: const Text('Set your height'),
                                        content: TextField(
                                          controller: heightController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText:
                                                'Enter your height in inches',
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              int? newHeight = int.tryParse(
                                                  heightController.text);
                                              if (newHeight != null) {
                                                viewModel.setHeightInInches(
                                                    newHeight);
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                  child: Text(
                                    'Height: ${viewModel.heightInInches} in',
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.fontSize,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String? selectedGender = viewModel.gender;
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            title:
                                                const Text('Set your gender'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                RadioListTile<String>(
                                                  title: const Text('Male'),
                                                  value: 'Male',
                                                  groupValue: selectedGender,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedGender = value;
                                                    });
                                                  },
                                                ),
                                                RadioListTile<String>(
                                                  title: const Text('Female'),
                                                  value: 'Female',
                                                  groupValue: selectedGender,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedGender = value;
                                                    });
                                                  },
                                                ),
                                                RadioListTile<String>(
                                                  title: const Text(
                                                      'Not specified'),
                                                  value: 'Not specified',
                                                  groupValue: selectedGender,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedGender = value;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  if (selectedGender != null) {
                                                    viewModel.setGender(
                                                        selectedGender!);
                                                  }
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                  child: Text(
                                    viewModel.gender,
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.fontSize,
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
                GestureDetector(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('MM-dd-yyyy').format(pickedDate);
                      viewModel.setBirthDate(formattedDate);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black45,
                      ),
                      child: ListTile(
                        title: const Text('Birthdate'),
                        subtitle: Text(viewModel.birthDate),
                        leading: const Icon(Icons.cake),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String? selectedLifestyle =
                            viewModel.getLifestyleAsString();
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: const Text('Set your lifestyle'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RadioListTile<String>(
                                    title: const Text('Sedentary'),
                                    subtitle:
                                        const Text('Little or no exercise'),
                                    value: 'Sedentary',
                                    groupValue: selectedLifestyle,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedLifestyle = value;
                                      });
                                    },
                                  ),
                                  RadioListTile<String>(
                                    title: const Text('Slightly Active'),
                                    subtitle:
                                        const Text('Exercise 1-3 times a week'),
                                    value: 'Slightly Active',
                                    groupValue: selectedLifestyle,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedLifestyle = value;
                                      });
                                    },
                                  ),
                                  RadioListTile<String>(
                                    title: const Text('Moderately Active'),
                                    subtitle:
                                        const Text('Exercise 3-5 times a week'),
                                    value: 'Moderately Active',
                                    groupValue: selectedLifestyle,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedLifestyle = value;
                                      });
                                    },
                                  ),
                                  RadioListTile<String>(
                                    title: const Text('Very Active'),
                                    subtitle:
                                        const Text('Exercise 6-7 times a week'),
                                    value: 'Very Active',
                                    groupValue: selectedLifestyle,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedLifestyle = value;
                                      });
                                    },
                                  ),
                                  RadioListTile<String>(
                                    title: const Text('Extremely Active'),
                                    subtitle: const Text(
                                        'Exercise multiple times a day'),
                                    value: 'Extremely Active',
                                    groupValue: selectedLifestyle,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedLifestyle = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    if (selectedLifestyle != null) {
                                      viewModel.setLifestyleByString(
                                          selectedLifestyle!);
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black26,
                      ),
                      child: ListTile(
                        title: const Text('Lifestyle'),
                        subtitle: Text(viewModel.getLifestyleAsString()),
                        leading: const Icon(Icons.run_circle),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black45,
                    ),
                    child: ListTile(
                      title: const Text('Logout'),
                      leading: const Icon(Icons.logout),
                      onTap: () {
                        Provider.of<AuthService>(context, listen: false)
                            .logout(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar:
          const NavBar(key: Key('customNavBar'), currentPage: 'SettingsView'),
    );
  }
}
