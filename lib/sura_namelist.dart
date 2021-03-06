import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:async' show Future;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamil_quran/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'about_us.dart';
import 'navigation.dart';
import 'read_sura.dart';

class SuraNames extends StatefulWidget {
  const SuraNames({Key? key}) : super(key: key);

  @override
  State<SuraNames> createState() => _SuraNamesState();
}

class _SuraNamesState extends State<SuraNames> {
  List _SuraList = [];
  int InputSura = 0;
  int InputVerse = 0;

  double _currentArabicFontSize = 22;
  double _currentTamilFontSize = 18;
  String _selectedTamilFont = 'MeeraInimai';
  String _selectedArabicFont = 'AlQalam';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              _SuraList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: _SuraList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                              child: ListTile(
                                title: Text(
                                  '${index + 1}. ${_SuraList[index]["name"]}',
                                  style: TextStyle(
                                      fontSize: _currentTamilFontSize,
                                      fontFamily: _selectedTamilFont,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${_SuraList[index]["name_arabic"]}',
                                  style: TextStyle(
                                      fontSize: _currentArabicFontSize,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: _selectedArabicFont),
                                  textDirection: TextDirection.rtl,
                                ),
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuraPage(selectedSura : index)));
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ReadSura(
                                            SuraNumber: _SuraList[index]
                                                ["surano"],
                                            SuraName:
                                                '${_SuraList[index]["name"]}',
                                            VerseNumber: 0,
                                          )));
                                },
                              ),
                            );
                          }),
                    )
                  : const Expanded(
                      child: Center(
                        child: SpinKitRing(
                          color: Colors.green,
                          size: 50.0,
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/sura_names.json');
    final data = await json.decode(response);
    setState(() {
      _SuraList = data["data"];
    });
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.green[900],
      //centerTitle: true,
      title: Text('???????????????????????????????????????'),
      automaticallyImplyLeading: false,

      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            NavigationService().navigateToScreen(Settings());
          },
        ),
        PopupMenuButton<int>(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              // row with 2 children
              child: Row(
                children: const [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("????????????????????????????????? ???????????????")
                ],
              ),
            ),
            // PopupMenuItem 1
            PopupMenuItem(
              value: 2,
              // row with 2 children
              child: Row(
                children: const [
                  Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Share This App")
                ],
              ),
            ),

            PopupMenuItem(
              value: 3,
              // row with 2 children
              child: Row(
                children: const [
                  Icon(
                    Icons.star_rate_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Rate This App")
                ],
              ),
            ),

            // PopupMenuItem 2
            PopupMenuItem(
              value: 4,
              // row with two children
              child: Row(
                children: const [
                  Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("About Us")
                ],
              ),
            ),
          ],
          offset: Offset(0, 20),
          color: Colors.white,
          elevation: 2,
          // on selected we show the dialog box
          onSelected: (value) {
            if (value == 1) {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('??????????????????????????????????????? ???????????????'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) {
                          InputSura = int.parse(value) - 1;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            hintText: "???????????????????????????????????? ????????????????????????",
                            label: Text("??????????????????????????????")),
                      ),
                      TextField(
                        onChanged: (value) {
                          InputVerse = int.parse(value);
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            hintText: "????????????????????? ????????????????????????", label: Text("???????????????")),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    OutlinedButton(
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ReadSura(
                                    SuraNumber: InputSura + 1,
                                    VerseNumber: InputVerse,
                                    SuraName: '${_SuraList[InputSura]["name"]}',
                                  ))),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            } else if (value == 2) {
              Share.share(
                  '??????????????????????????????????????? ???????????????????????????????????? ?????????????????? Android ?????????????????????????????? ????????????????????? ???????????? ??????????????????????????? ?????????????????? ????????????????????????????????? ?????????????????????????????????  : https://bit.ly/TamilQuran');
            } else if (value == 3) {
              _launchURL(
                  'https://play.google.com/store/apps/details?id=com.faheemapps.tamil_quran');
            } else if (value == 4) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AboutUs()));
            }
          },
        ),
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void loadSelections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentTamilFontSize = (prefs.getDouble('tamilFontSize') ?? 18);
      _currentArabicFontSize = (prefs.getDouble('arabicFontSize') ?? 22);
      _selectedTamilFont =
          (prefs.getString('selectedTamilFont') ?? 'MeeraInimai');
      _selectedArabicFont =
          (prefs.getString('selectedArabicFont') ?? 'AlQalam');
    });
  }

  @override
  void initState() {
    super.initState();
    this.readJson();
    loadSelections();
  }
}
