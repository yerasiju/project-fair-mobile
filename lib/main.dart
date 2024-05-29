import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Facility> facilities = [
    Facility(
      name: 'Sport Hall',
      location: 'Main Building',
      imageUrl: 'https://example.com/sport_hall.jpg',
    ),
    Facility(
      name: 'Activity Hall',
      location: 'Community Center',
      imageUrl: 'https://example.com/activity_hall.jpg',
    ),
    Facility(
      name: 'Football Pitch',
      location: 'Sports Complex',
      imageUrl: 'https://example.com/football_pitch.jpg',
    ),
    Facility(
      name: 'Alcove',
      location: 'Park Area',
      imageUrl: 'https://example.com/alcove.jpg',
    ),
  ];

  List<Facility> filteredFacilities = [];
  TextEditingController _searchController = TextEditingController();
  String selectedFacilityType = 'All Facilities';

  @override
  void initState() {
    super.initState();
    filteredFacilities = facilities;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterFacilities();
  }

  void _filterFacilities() {
    String query = _searchController.text.toLowerCase();
    String facilityType = selectedFacilityType.toLowerCase();
    setState(() {
      filteredFacilities = facilities.where((facility) {
        bool matchesQuery = facility.name.toLowerCase().contains(query) ||
            facility.location.toLowerCase().contains(query);
        bool matchesType = facilityType == 'all facilities' || facility.name.toLowerCase() == facilityType;
        return matchesQuery && matchesType;
      }).toList();
    });
  }

  void _showFacilityTypeFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Facility Type'),
          content: DropdownButton<String>(
            isExpanded: true,
            value: selectedFacilityType,
            items: <String>[
              'All Facilities',
              'Sport Hall',
              'Activity Hall',
              'Football Pitch',
              'Alcove',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedFacilityType = newValue!;
                _filterFacilities();
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Facility Booking',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              filteredFacilities = facilities;
                            });
                          },
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.filter_list, size: 30.0),
                  onPressed: _showFacilityTypeFilterDialog,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(4.0),
              itemCount: filteredFacilities.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(facility: filteredFacilities[index]),
                      ),
                    );
                  },
                  child: _buildCard(filteredFacilities[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Facility facility) {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(0.0),
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(15.0),
        ),
        side: BorderSide(
          color: Colors.grey,
          width: 0,
        ),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(0.0),
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(0.0),
                ),
                child: Image.network(
                  facility.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Icon(Icons.error);
                  },
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    facility.name,
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        facility.location,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
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

class DetailPage extends StatelessWidget {
  final Facility facility;

  DetailPage({required this.facility});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          facility.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                  child: Image.network(
                    facility.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Icon(Icons.error, size: 100);
                    },
                  ),
                ),
                Positioned(
                  top: 120,
                  left: 16,
                  right: 16,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            facility.name,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text(
                                facility.location,
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      _buildLabeledText('Facility available for booking'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledText(String text) {
    return SizedBox(
      height: 50,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class Facility {
  final String name;
  final String location;
  final String imageUrl;

  Facility({
    required this.name,
    required this.location,
    required this.imageUrl,
  });
}
