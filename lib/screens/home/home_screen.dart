import 'package:flutter/material.dart';
import 'package:wise_verbs/constants/constants.dart';
import 'package:wise_verbs/widget/loading_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: AspectRatio(
                      aspectRatio: 5 / 1.5,
                      child: Image.asset(
                        launchLogo,
                      ))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Popular Quotes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 1)),
                builder: (context,snapshot) {
                  if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.waiting){
                    return const LoadingWidget();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: 30,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return AnimationWidget(index: index);
                    },
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimationWidget extends StatefulWidget {
  final int index;

  const AnimationWidget({super.key, required this.index});

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    // Set a delay to start the animation for each item
    Future.delayed(Duration(milliseconds: widget.index * 300), () {
      if(mounted){
        setState(() {
          isVisible = true;
        });
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.fastLinearToSlowEaseIn,
      child: popularQuoteItemWidget(),
    );
  }

  Widget popularQuoteItemWidget() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      margin: const EdgeInsets.all(15),
      curve: Curves.fastLinearToSlowEaseIn,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                foregroundColor: dodgerBlue,
                child: Text(
                  'A',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: dodgerBlue, fontWeight: FontWeight.w600),
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("'Hihedvfjahdkjabdkjahsbdkjfahbdkfjhabsdkjhbasdkjbfakjhdbfakjhdfb'"),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 20,),
              IconButton(onPressed: (){
                setState(() {
                  color = Colors.orange;
                });
              }, icon: Image.asset(likeButton,height: 25,color: color,),),
              IconButton(onPressed: (){}, icon: const Icon(Icons.share,size: 23,),),
              IconButton(onPressed: (){}, icon: const Icon(Icons.copy,size: 23,),),
            ],
          )
        ],
      ),
    );
  }
  Color color = Colors.white;
}
