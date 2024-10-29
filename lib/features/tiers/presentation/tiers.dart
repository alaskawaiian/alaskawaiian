import 'package:flutter/material.dart';

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

  TierCard({required this.tier, required this.progress, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: tier.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tier.tierName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '$points points',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ...tier.benefits.map((benefit) => Text(benefit)).toList(),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            color: tier.color,
            backgroundColor: tier.color.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

class Tiers extends StatelessWidget {
  final List<Tier> tiers = [
    Tier(
      tierName: 'Ocean',
      benefits: ['Priority Boarding', 'Extra Baggage Allowance'],
      color: Colors.blueAccent,
      minPoints: 0,
    ),
    Tier(
      tierName: 'Land',
      benefits: ['Lounge Access', 'Priority Check-in'],
      color: Colors.green,
      minPoints: 1000,
    ),
    Tier(
      tierName: 'Mountain',
      benefits: ['Free Upgrades', 'Exclusive Offers'],
      color: Colors.orange,
      minPoints: 2000,
    ),
    Tier(
      tierName: 'Sky',
      benefits: ['Complimentary Service', 'Early Access to Tickets'],
      color: Colors.blue,
      minPoints: 5000,
    ),
  ];

  final int points = 1250; // Edit amount of miles here.

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
      appBar: AppBar(
        title: Text('Alaskawaiian Tiers'),
      ),
      body: Center(
        child: TierCard(tier: currentTier, progress: progress, points: points),
      ),
    );
  }
}
