import 'package:flutter/material.dart';

import '/features/custom_colors.dart';

class Tier {
  final String tierName;
  final List<String> benefits;
  final Color color;
  final int minPoints;

  Tier({
    required this.tierName,
    required this.benefits,
    required this.color,
    required this.minPoints,
  });
}

class TierCard extends StatelessWidget {
  final Tier tier;
  final double progress;
  final int points;
  final int nextPoints;

  TierCard(
      {required this.tier,
      required this.progress,
      required this.points,
      required this.nextPoints});

  final List<Map<String, dynamic>> tiers = [
    {
      "name": "Sky Tier",
      "miles": 5000,
      "benefits": [
        '1. Complimentary Service: Receive free in-flight services such as meals, drinks, and entertainment upgrades.',
        '2. Early Access to Tickets: Be the first to purchase tickets, ensuring access to the best routes and seats.',
      ],
    },
    {
      "name": "Mountain Tier",
      "miles": 2000,
      "benefits": [
        '1. Free Upgrades: Enjoy complimentary upgrades to premium seating or cabins whenever available.',
        '2. Exclusive Offers: Access special discounts, early sales, and unique promotions reserved for this tier.',
      ],
    },
    {
      "name": "Land Tier",
      "miles": 1000,
      "benefits": [
        '1. Lounge Access: Relax in exclusive airport lounges with free Wi-Fi, snacks, and a calm atmosphere before your flight.',
        '2. Priority Check-in: Skip the regular check-in lines with a dedicated counter for faster service.',
      ],
    },
    {
      "name": "Ocean Tier",
      "miles": 0,
      "benefits": [
        '1. Priority Boarding: Board the plane early to ensure overhead storage space and a comfortable boarding process.',
        '2. Extra Baggage Allowance: Enjoy an additional baggage allowance for longer trips or extra luggage needs.',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [hawaiianPink, alaskaBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(150.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tiers',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Jomolhari',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Current Points: $points points',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white70,
                          fontFamily: 'Jomolhari',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 4.0,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Current Tier: ${tier.tierName}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Jomolhari',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: tier.benefits
                                  .map((benefit) => Text(benefit))
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '$nextPoints points',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: progress,
                            color: tier.color,
                            backgroundColor: tier.color.withOpacity(0.5),
                          ),
                          SizedBox(height: 30),
                          Expanded(
                            child: Column(
                              children: tiers.map((tier) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(tier['name']),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: tier['benefits']
                                                .map<Widget>((benefit) => Padding(
                                              padding: const EdgeInsets.only(bottom: 10),
                                              child: Text(benefit),
                                            ))
                                                .toList(),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text('Close'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: TierWidget(
                                    tierName: tier['name'],
                                    miles: tier['miles'],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
      )
    );
  }
}

class TierWidget extends StatelessWidget {
  final String tierName;
  final int miles;

  const TierWidget({required this.tierName, required this.miles});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [hawaiianPink, alaskaBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tierName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Jomolhari',
            ),
          ),
          Text(
            '$miles miles',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontFamily: 'Jomolhari',
            ),
          ),
        ],
      ),
    );
  }
}

class Tiers extends StatelessWidget {
  final List<Tier> tiers = [
    Tier(
      tierName: 'Ocean Tier',
      benefits: ['Priority Boarding', 'Extra Baggage Allowance'],
      color: Colors.blueAccent,
      minPoints: 0,
    ),
    Tier(
      tierName: 'Land Tier',
      benefits: ['Lounge Access', 'Priority Check-in'],
      color: Colors.green,
      minPoints: 1000,
    ),
    Tier(
      tierName: 'Mountain Tier',
      benefits: ['Free Upgrades', 'Exclusive Offers'],
      color: Colors.orange,
      minPoints: 2000,
    ),
    Tier(
      tierName: 'Sky Tier',
      benefits: ['Complimentary Service', 'Early Access to Tickets'],
      color: Colors.blue,
      minPoints: 5000,
    ),
  ];

  final int points = 1250;

  @override
  Widget build(BuildContext context) {
    Tier currentTier = tiers.first;
    Tier nextTier = tiers.last;
    double progress = 0.0;

    for (int i = 0; i < tiers.length; i++) {
      if (points >= tiers[i].minPoints) {
        currentTier = tiers[i];
        if (i < tiers.length - 1) {
          nextTier = tiers[i + 1];
        }
      }
    }

    if (points < nextTier.minPoints) {
      progress = (points - currentTier.minPoints) /
          (nextTier.minPoints - currentTier.minPoints);
    } else {
      progress = 1.0;
    }

    return Scaffold(
      body: Center(
        child: TierCard(
            tier: currentTier,
            progress: progress,
            points: points,
            nextPoints: nextTier.minPoints),
      ),
    );
  }
}