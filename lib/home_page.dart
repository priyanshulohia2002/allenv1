import 'package:allen/feature_box.dart';
import 'package:allen/openai_service.dart';
import 'package:allen/pallete.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          child: const Text('Allen'),
        ),
        // leading: const Icon(Icons.menu),
        // centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        centerTitle: true,
      ),
      //
      //

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Pallete.secondSuggestionBoxColor,
              ),
              child: Text(
                'W.E.L.C.O.M.E',
                style: TextStyle(
                  color: Pallete.whiteColor,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Handle item 1 tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.new_label),
              title: const Text('New Chat'),
              onTap: () {
                // Handle item 2 tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_border_outlined),
              title: const Text('Social'),
              onTap: () {
                // Handle item 2 tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Account'),
              onTap: () {
                // Handle item 2 tap
              },
            ),
          ],
        ),
      ),
      //
      //
      // like list view
      body: SingleChildScrollView(
        child: Column(
          children: [
            // virtual assistant picture
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        // color: Pallete.assistantCircleColor,
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    height: 140,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/virtualAssistant3.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // chat bubble
            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                    top: 30,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Pallete.borderColor,
                    ),
                    borderRadius: BorderRadius.circular(20).copyWith(
                      topLeft: Radius.zero,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      generatedContent == null
                          ? 'Good Morning, what task can I do for you?'
                          : generatedContent!,
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallete.mainFontColor,
                        fontSize: generatedContent == null ? 25 : 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // padding to show image
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(generatedImageUrl!),
                ),
              ),
            // next line
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  child: const Text(
                    'Here are a few features',
                    style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // features list
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: const FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headerText: 'ChatGPT',
                      descriptionText:
                          'A smarter way to stay organized and informed with ChatGPT',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: const FeatureBox(
                      color: Pallete.secondSuggestionBoxColor,
                      headerText: 'Dall-E',
                      descriptionText:
                          'Get inspired and stay creative with your personal assistant powered by Dall-E',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + 2 * delay),
                    child: const FeatureBox(
                      color: Pallete.thirdSuggestionBoxColor,
                      headerText: 'Smart Voice Assistant',
                      descriptionText:
                          'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 45,
                vertical: 5,
              ),
            ),
            SlideInLeft(
              delay: Duration(milliseconds: start + 2 * delay),
              child: SizedBox(
                width: 335,
                child: TextField(
                  controller: _controller,
                  // magnifierConfiguration: ,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          15.0), // Adjust the value as needed
                    ),
                    // border: const OutlineInputBorder(),
                    hintStyle: const TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.blackColor,
                      fontSize: 18,
                    ),
                    hintText: 'What\'s on your mind?',
                    suffixIcon: IconButton(
                      onPressed: () {
                        //clear
                        _controller.clear();
                      },
                      icon: const Icon(Icons.clear),
                      // icon: const Icon(Icons.search, color: Colors.blue),
                    ),
                    //generatedContent= chatGPTAPI(_controller.text);
                    prefixIcon: IconButton(
                      onPressed: () async {
                        generatedImageUrl = null;
                        //
                        final String spch;
                        // condition applied that if the string of input contains "image" then call for dall-e api
                        if (_controller.text.contains('image')) {
                          // will recieve image url in spch
                          spch = await openAIService.dallEAPI(_controller.text);
                        } else {
                          spch =
                              await openAIService.chatGPTAPI(_controller.text);
                        }
                        // final spch = await openAIService.chatGPTAPI(_controller.text);

                        // final spch = await dallEAPI(_controller.text);
                        if (!spch.contains('http')) {
                          generatedImageUrl = null;
                          generatedContent = spch;
                          setState(() {});
                          await systemSpeak(spch);
                        }
                        //
                        else {
                          generatedImageUrl = spch;
                          generatedContent = null;
                          setState(() {});
                          // goes to line 216
                          // await systemSpeak(spch);
                        }
                        //
                        // setState(() {});
                        // await systemSpeak(speech);
                      },
                      icon: const Icon(Icons.search, color: Colors.blue),
                      // static const IconData send = IconData(0xe571, fontFamily: 'MaterialIcons', matchTextDirection: true),
                    ),
                  ),
                ),
              ),
              // MaterialButton(
              //   onPressed:(){
              //     generatedImageUrl = null;
              //     generatedContent = _controller.text;
              //     child: const Text('Post', style: TextStyle(color:Colors.white)),
              //     setState(() {});
              //     },
              // ),
              //),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 45,
                vertical: 5,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech = await openAIService.isArtPromptAPI(lastWords);
              if (speech.contains('https')) {
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedImageUrl = null;
                generatedContent = speech;
                setState(() {});
                await systemSpeak(speech);
              }
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          child: Icon(
            speechToText.isListening ? Icons.stop : Icons.mic,
          ),
        ),
      ),
    );
  }
}
