import 'package:aqarat_flutter_project/backend/search.dart';
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// untils here -----------------------------

import 'postsDetail.dart';

// Enum for sorting options
enum SortOption {
  priceAsc,
  priceDesc,
  bedroomsAsc,
  bedroomsDesc,
  bathroomsAsc,
  bathroomsDesc,
  location,
  dateAddedNewest,
  dateAddedOldest,
}

// Custom Search Class to handle search logic
class PropertySearch {
  String? searchQuery;
  String? propertyType;
  String? city;
  String? address;
  SortOption? sortBy;

  PropertySearch({
    this.searchQuery,
    this.propertyType,
    this.city,
    this.address,
    this.sortBy,
  });

  void reset() {
    searchQuery = null;
    propertyType = null;
    city = null;
    address = null;
    sortBy = null;
  }
}

// Property result model
class PropertyResult {
  final String postId;
  final String id;
  final String location;
  final String type;
  final String city;
  final String address;
  final String price;
  final int priceValue; // Numeric value for sorting
  final int bedrooms;
  final int bathrooms;
  final DateTime dateAdded;
  final DateTime dateUpdated;
  final String area;

  PropertyResult({
    required this.postId,
    required this.id,
    required this.location,
    required this.type,
    required this.city,
    required this.address,
    required this.price,
    required this.priceValue,
    required this.bedrooms,
    required this.bathrooms,
    required this.dateAdded,
    required this.dateUpdated,
    required this.area,
  });
}

class SearchPage extends StatefulWidget {
  final Locale myLocale;
  const SearchPage({super.key, required this.myLocale});

  @override
  State<SearchPage> createState() => _SearchPage(MyLocale: myLocale);
}

class _SearchPage extends State<SearchPage> {
  final Locale MyLocale;
  final PropertySearch _propertySearch = PropertySearch();
  final TextEditingController _searchController = TextEditingController();

  List<PropertyResult> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  _SearchPage({required this.MyLocale});

  List<bool> isBookmarked = [];
  List<bool> isAvilable = [];

  // dynamic city & address lists
  List<City> _cities = [];
  List<Address> _addresses = [];
  List<StateType> _stateTypes = [];
  List<MiniOption> _optionsList = [];

  String _formatPrice(dynamic rawValue) {
    if (rawValue == null) return "--";
    final trimmed = rawValue.toString().trim();
    if (trimmed.isEmpty || trimmed == "--") return "--";
    return trimmed.startsWith("\$") ? trimmed : "\$$trimmed";
  }

  Future<void> _loadLocations() async {
    try {
      List<City> cities = await fetchLocations(
        lang: MyLocale.languageCode.toLowerCase(),
      );
      setState(() {
        _cities = cities;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).FailedToLoadLocation + '$e')),
      );
    }
  }

  void _onCitySelected(String? selectedCityName) {
    setState(() {
      _propertySearch.city = selectedCityName;
      // Find the city object
      City? selectedCity = _cities.firstWhere(
        (c) => c.cityName == selectedCityName,
        orElse: () => City(cityId: 0, cityName: '', addresses: []),
      );
      _addresses = selectedCity.addresses;
      _propertySearch.address = null; // reset address selection
    });
  }

  Future<void> _loadStateTypes() async {
    try {
      List<StateType> stateTypes = await fetchStateTypes(
        MyLocale.languageCode.toLowerCase(),
      );
      setState(() {
        _stateTypes = stateTypes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).FailedToLoadStateTypes + '$e')),
      );
    }
  }

  void _onStateTypeSelected(String? selectedTypeName) {
    setState(() {
      _propertySearch.propertyType = selectedTypeName;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLocations();
    _loadStateTypes();

    isBookmarked = List.generate(_searchResults.length, (index) => false);
    isAvilable = List.generate(_searchResults.length, (index) => true);
  }

  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Get sort option display text
  String getSortOptionText(SortOption option) {
    switch (option) {
      case SortOption.priceAsc:
        return S.of(context).PriceLowToHigh;
      case SortOption.priceDesc:
        return S.of(context).PriceHighToLow;
      case SortOption.bedroomsAsc:
        return S.of(context).BedroomsLowToHigh;
      case SortOption.bedroomsDesc:
        return S.of(context).BedroomsHighToLow;
      case SortOption.bathroomsAsc:
        return S.of(context).BathroomsLowToHigh;
      case SortOption.bathroomsDesc:
        return S.of(context).BathroomsHighToLow;
      case SortOption.location:
        return S.of(context).LocationAToZ;
      case SortOption.dateAddedNewest:
        return S.of(context).DateNewToOld;
      case SortOption.dateAddedOldest:
        return S.of(context).DateOLdtoNew;
    }
  }

  // Get sort option English text for API
  String getSortOptionEnglish(SortOption option) {
    switch (option) {
      case SortOption.priceAsc:
        return 'Price: Low To High';
      case SortOption.priceDesc:
        return 'Price: High To Low';
      case SortOption.bedroomsAsc:
        return 'Bedrooms: Low To High';
      case SortOption.bedroomsDesc:
        return 'Bedrooms: High To Low';
      case SortOption.bathroomsAsc:
        return 'Bathrooms: Low To High';
      case SortOption.bathroomsDesc:
        return 'Bathrooms: High To Low';
      case SortOption.location:
        return 'Location : A-Z';
      case SortOption.dateAddedNewest:
        return 'Date: Newest First';
      case SortOption.dateAddedOldest:
        return 'Date: Oldest First';
    }
  }

  // Perform search function
  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    _propertySearch.searchQuery = _searchController.text;

    try {
      // Fetch REAL data from API
      _optionsList = await fetchSortOptions(
        MyLocale.languageCode.toLowerCase(),
        city: _propertySearch.city,
        address: _propertySearch.address,
        stateType: _propertySearch.propertyType,
        sortBy: _propertySearch.sortBy != null
            ? getSortOptionEnglish(_propertySearch.sortBy!)
            : null,
      );

      print(
        S.of(context).Fetched +
            '${_optionsList.length}' +
            S.of(context).Options,
      ); // Debug log

      setState(() {
        _searchResults = _optionsList.isNotEmpty
            ? _convertMiniOptionsToPropertyResults(_optionsList)
            : [];
        isBookmarked = List.generate(_searchResults.length, (index) => false);
        _hasSearched = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print(S.of(context).Error + '$e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).SearchFailed + '$e')),
      );
    }
  }

  // Helper function to convert API data to your UI model
  List<PropertyResult> _convertMiniOptionsToPropertyResults(
    List<MiniOption> options,
  ) {
    return options
        .map(
          (option) => PropertyResult(
            postId: option.postId,
            id: option.username,
            location: option.city, // or combine city + address
            type: option.stateType,
            city: option.city,
            address: option.address,
            price: option.prize,
            priceValue: int.tryParse(option.prize) ?? 0,

            bedrooms:
                int.tryParse(option.bedrooms) ??
                0, // You need to get this from API
            bathrooms:
                int.tryParse(option.bathrooms) ??
                0, // You need to get this from API
            dateAdded: DateTime.now(),
            dateUpdated: DateTime.now(),
            area: option.area,
          ),
        )
        .toList();
  }

  // Clear search function
  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _propertySearch.reset();
      _searchResults.clear();
      _hasSearched = false;
    });
  }

  // Format date for display
  String _formatDate(DateTime date) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(date);

    // take the data information from data base ---------------------

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}' + S.of(context).mAgo;
      }
      return '${difference.inHours}' + S.of(context).hAgo;
    } else if (difference.inDays == 1) {
      return S.of(context).Yesterday;
    } else if (difference.inDays < 7) {
      return '${difference.inDays}' + S.of(context).dAgo;
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: MyLocale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(0xff1E3A8A),
                        size: 30,
                      ),
                    ),
                    if (_hasSearched)
                      MaterialButton(
                        onPressed: _clearSearch,
                        child: Text(
                          S.of(context).Clear,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  S.of(context).Search,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.brown[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                // Search TextField
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: S.of(context).SearchByLocation,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  onSubmitted: (value) => _performSearch(),
                ),
                SizedBox(height: 16),

                // Property Type Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.apartment),
                  ),
                  hint: Text(S.of(context).PropertyType),
                  value: _propertySearch.propertyType,

                  // take items from data abse -----------------------------------------------
                  items: _stateTypes
                      .map(
                        (type) => DropdownMenuItem(
                          value: type.typeName,
                          child: Text(type.typeName),
                        ),
                      )
                      .toList(),
                  onChanged: _onStateTypeSelected,
                ),
                SizedBox(height: 20),

                // City and Address Row
                Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      hint: Text(S.of(context).City),
                      value: _propertySearch.city,
                      // take cities from data base
                      items: _cities
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.cityName,
                              child: Text(c.cityName),
                            ),
                          )
                          .toList(),
                      onChanged: _onCitySelected,
                    ),

                    SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.place),
                      ),
                      hint: Text(S.of(context).Address),
                      value: _propertySearch.address,
                      items: _addresses
                          .map(
                            (a) => DropdownMenuItem(
                              value: a.addressName,
                              child: Text(a.addressName),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _propertySearch.address = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Sort By Dropdown
                DropdownButtonFormField<SortOption>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.sort),
                  ),
                  hint: Text(S.of(context).SortBy),
                  value: _propertySearch.sortBy,
                  items: SortOption.values
                      .map(
                        (option) => DropdownMenuItem(
                          value: option,
                          child: Text(getSortOptionText(option)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _propertySearch.sortBy = value;
                    });
                  },
                ),
                SizedBox(height: 30),

                // Search Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _performSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1A2A6C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            S.of(context).Search,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),

                SizedBox(height: 20),

                // Search Results
                if (_hasSearched)
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).SearchResult +
                                  '${_searchResults.length}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[400],
                              ),
                            ),
                            // Quick sort buttons for convenience
                            if (_searchResults.isNotEmpty)
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _propertySearch.sortBy =
                                            SortOption.dateAddedNewest;
                                      });
                                      _performSearch();
                                    },
                                    icon: Icon(Icons.fiber_new, size: 20),
                                    tooltip: S.of(context).AddSortByNewest,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _propertySearch.sortBy =
                                            SortOption.priceAsc;
                                      });
                                      _performSearch();
                                    },
                                    icon: Icon(Icons.arrow_upward, size: 20),
                                    tooltip: S
                                        .of(context)
                                        .SortByPriceAddedLowToHigh,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _propertySearch.sortBy =
                                            SortOption.priceDesc;
                                      });
                                      _performSearch();
                                    },
                                    icon: Icon(Icons.arrow_downward, size: 20),
                                    tooltip: S
                                        .of(context)
                                        .SortByPriceAddedHighToLow,
                                  ),
                                ],
                              ),
                          ],
                        ),
                        if (_propertySearch.sortBy != null)
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              S.of(context).SortedBy +
                                  '${getSortOptionText(_propertySearch.sortBy!)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        SizedBox(height: 10),
                        Container(
                          child: _searchResults.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        S.of(context).NoPropertyiesFound,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              //herrrrrrreeeee
                              //------------------------------------------------------
                              //--------------------------------------
                              //--------------------------------------
                              //--------------------------------------
                              //--------------------------------------
                              //--------------------------------------
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _searchResults.length,
                                  itemBuilder: (context, index) {
                                    PropertyResult property =
                                        _searchResults[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => itemDetails(
                                              myLocale: MyLocale,
                                              username:
                                                  _optionsList[index].username,
                                              postID: int.parse(
                                                _optionsList[index].postId,
                                              ),
                                              profilePic: _optionsList[index]
                                                  .profilePic,
                                              location:
                                                  _optionsList[index].city +
                                                  ' ' +
                                                  _optionsList[index].address,
                                              price: _optionsList[index].prize,
                                              area: int.parse(
                                                _optionsList[index].area,
                                              ),
                                              bedroom: int.parse(
                                                _optionsList[index].bedrooms,
                                              ),
                                              bathroom: int.parse(
                                                _optionsList[index].bathrooms,
                                              ),
                                              roomNum: int.parse(
                                                _optionsList[index].bedrooms,
                                              ),
                                              discription: '',
                                              facade: '',
                                              condetion: '',
                                              floorNum: 0,
                                              city: _optionsList[index].city,
                                              address:
                                                  _optionsList[index].address,
                                              state:
                                                  _optionsList[index].stateType,
                                              image1: _optionsList[index]
                                                  .mediaPath1,
                                              phoneNum: null,
                                              available: true,
                                              image2: null,
                                              image3: null,
                                              image4: null,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        margin: EdgeInsets.only(
                                          bottom: 12,
                                          right: 10,
                                          left: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        elevation: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Header Row: Icon + Property Type
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Color(
                                                        0xFF1A2A6C,
                                                      ).withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            50,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      // take teh property type from data base ----------------------
                                                      _optionsList[index]
                                                                  .stateType ==
                                                              S
                                                                  .of(context)
                                                                  .Apartment
                                                          ? Icons.apartment
                                                          : _optionsList[index]
                                                                    .stateType ==
                                                                S
                                                                    .of(context)
                                                                    .House
                                                          ? Icons.house
                                                          : Icons.villa,
                                                      color: Color(0xFF1A2A6C),
                                                      size: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Container(
                                                    child: Text(
                                                      // take the property type from data base --------------------
                                                      "${_optionsList[index].stateType}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  
                                                ],
                                              ),
                                              const SizedBox(height: 10),

                                              // Date information row
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.schedule,
                                                        size: 16,
                                                        color: Colors.grey[600],
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        "Added : " +
                                                            '${_formatDate(property.dateAdded)}',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),

                                              // Property Image Placeholder
                                              Container(
                                                height: 120,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                // take the image from data base --------------------------------------
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                  child: Image.network(
                                                    "${_optionsList[index].mediaPath1}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),

                                              // Price
                                              Row(
                                                children: [
                                                  Text(
                                                    // take teh price from data base --------------------------
                                                    _formatPrice(
                                                      _optionsList[index].prize,
                                                    ),
                                                    style: TextStyle(
                                                      color: Color(0xff1E3A8A),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 20),

                                                  // availability message -----------------------------------------------
                                                  // Container(
                                                  //   padding:
                                                  //       EdgeInsets.symmetric(
                                                  //         horizontal: 6,
                                                  //         vertical: 2,
                                                  //       ),
                                                  //   decoration: BoxDecoration(
                                                  //     color: isAvilable[index]
                                                  //         ? Colors.green
                                                  //         : Colors.red,
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(
                                                  //           4,
                                                  //         ),
                                                  //   ),
                                                  //   child: Text(
                                                  //     isAvilable[index]
                                                  //         ? S
                                                  //               .of(context)
                                                  //               .Avilable
                                                  //         : S
                                                  //               .of(context)
                                                  //               .NotAvilable,
                                                  //     style: TextStyle(
                                                  //       color: Colors.white,
                                                  //       fontSize: 9,
                                                  //       fontWeight:
                                                  //           FontWeight.bold,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),

                                              // Location & Address
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      // take the location from data base --------------------------
                                                      "${_optionsList[index].city}" +
                                                          " - " +
                                                          "${_optionsList[index].address}",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(
                                                          0xff000929,
                                                        ),
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      // take teh property city from data base ------------------------
                                                      '${_optionsList[index].city}, ${_optionsList[index].address}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color(
                                                          0xff000929,
                                                        ),
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10),

                                              Divider(
                                                height: 1,
                                                thickness: 1,
                                                color: Colors.grey[300],
                                              ),

                                              const SizedBox(height: 10),
                                              // Bottom Info Row: Bedrooms, Bathrooms, ID
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.bed,
                                                        size: 20,
                                                        color: Color(
                                                          0xff7065F0,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),

                                                      // take bedroom number from data base --------------------------
                                                      Text(
                                                        '${_optionsList[index].bedrooms}',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.bathtub,
                                                        size: 20,
                                                        color: Color(
                                                          0xff7065F0,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),

                                                      // take bathrooms number from data base ------------------
                                                      Text(
                                                        '${property.bathrooms}',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.square_foot,
                                                        size: 20,
                                                        color: Color(
                                                          0xff7065F0,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      // take the area number from data base --------------------------
                                                      Text(
                                                        '${_optionsList[index].area} m²',
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
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
  }
}
