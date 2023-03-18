import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TopBarWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool quickGuide;
  final bool notificationEnabled;

  TopBarWidget(this.title, this.subtitle, {Key key, this.quickGuide: false, this.notificationEnabled : true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) return Container();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Color(
                      0xff333333,
                    ),
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              SizedBox(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: Color(
                      0xff828282,
                    ),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 24,
        ),
        Expanded(
          flex: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (quickGuide)
                InkWell(
                  onTap: (){
                    return showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        YoutubePlayerController _controller = YoutubePlayerController(
                          initialVideoId: '8yuNQreXtaE',
                          params: YoutubePlayerParams(
                            playlist: [], // Defining custom playlist
                            startAt: Duration(seconds: 0),
                            showControls: true,
                            autoPlay: true,
                            showFullscreenButton: true,
                          ),
                        );

                        return AlertDialog(
                          // title: const Text('AlertDialog Title'),
                          content: Center(
                            child: YoutubePlayerControllerProvider(
                              // Provides controller to all the widget below it.
                              controller: _controller,
                              child: YoutubePlayerIFrame(
                                aspectRatio: 16 / 9,
                              ),
                            ),
                          ),
                        );
                      },
                    );

                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      'Quick Guide',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 152, 219, 1),
                          // fontFamily: 'Poppins',
                          fontSize: 14,
                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ),
                ),
              // notificationEnabled?Image.asset(
              //   "assets/images/Desktop Notification.png",
              //   width: 35,
              //   height: 35,
              //   semanticLabel: "icon",
              // ):Container(),
              SizedBox(
                width: 24,
              ),
              Image.asset(
                "assets/images/Ellipse 3.png",
                width: 35,
                height: 35,
              ),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}
