// ignore_for_file: avoid_function_literals_in_foreach_calls, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mmanage/backend/chitti_service.dart';
import 'package:mmanage/constants/colors.dart';
import 'package:mmanage/constants/styles.dart';
import 'package:mmanage/constants/util.dart';
import 'package:mmanage/modules/Chitti/chitti_card.dart';
import 'package:mmanage/modules/Chitti/chitti_form.dart';
import 'package:provider/provider.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

class ChittiScreen extends StatefulWidget {
  const ChittiScreen({Key? key}) : super(key: key);

  @override
  State<ChittiScreen> createState() => _ChittiScreenState();
}

class _ChittiScreenState extends State<ChittiScreen> {
  @override
  void initState() {
    Provider.of<ChittiService>(context, listen: false).getChittiData();
    super.initState();
  }

  openForm() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ChittiFromScreen()));
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ChittiService>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.filler,
        onPressed: openForm,
        child: Icon(Icons.add),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopSection(data: data),
            Expanded(
              child: ContainedTabBarView(
                tabBarProperties:TabBarProperties(
                  indicatorColor: AppTheme.filler,
                ),
                tabs: [
                  Text(
                    "Active Chitti's",
                    style: Styles.textDecoration(color: Colors.black87),
                  ),
                  Text("Completed Chitti's",
                      style: Styles.textDecoration(color: Colors.black87))
                ],
                views: [
                  ActiveChittiSection(data: data),
                  CompletedChittiSection(data: data)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveChittiSection extends StatelessWidget {
  const ActiveChittiSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ChittiService data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: ((context, index) {
                if (data.chitti[index]['isActive']) {
                  return ChittiCard(
                    chitti: data.chitti[index],
                  );
                }
                return Text("");
              }),
              itemCount: data.chitti.length,
            ),
          )
        ],
      ),
    );
  }
}

class CompletedChittiSection extends StatelessWidget {
  const CompletedChittiSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ChittiService data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: ((context, index) {
                if (!data.chitti[index]['isActive']) {
                  return ChittiCard(
                    chitti: data.chitti[index],
                  );
                }
                return Text("");
              }),
              itemCount: data.chitti.length,
            ),
          )
        ],
      ),
    );
  }
}

class TopSection extends StatelessWidget {
  const TopSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ChittiService data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Card(
        color: AppTheme.filler.withOpacity(1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Center(
                    child: Text("Total Value",
                        style: Styles.textDecoration(
                            color: AppTheme.secondaryText,
                            fontWeight: FontWeight.bold)),
                  ),
                  Center(
                    child: Text(
                      Util.formatMoney(data.totalChittiAmount),
                      style: Styles.textDecoration(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Active Chitti's",
                          style: Styles.textDecoration(
                              color: AppTheme.secondaryText,
                              fontWeight: FontWeight.bold)),
                      Text(
                        '${data.chittiSize}',
                        style: Styles.textDecoration(fontSize: 20),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Amount Paid",
                        style: Styles.textDecoration(
                            color: AppTheme.secondaryText,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Util.formatMoney(data.amountPaid),
                        style: Styles.textDecoration(fontSize: 20),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Amount Recived",
                        style: Styles.textDecoration(
                            color: AppTheme.secondaryText,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Util.formatMoney(data.amountRecived),
                        style: Styles.textDecoration(fontSize: 20),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChittiFromScreen extends StatefulWidget {
  const ChittiFromScreen({Key? key}) : super(key: key);

  @override
  State<ChittiFromScreen> createState() => _ChittiFromState();
}

class _ChittiFromState extends State<ChittiFromScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: AppTheme.primaryText,
            ),
          ),
          title: const Text(
            "mManage",
          ),
          backgroundColor: AppTheme.filler,
        ),
        body: ChittiForm());
  }
}
