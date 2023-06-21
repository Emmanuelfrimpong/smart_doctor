// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class TipsModel {
  String id;
  String? doctor_name;
  String? health_tip;
  int? createdAt;
  TipsModel({
    required this.id,
    this.doctor_name,
    this.health_tip,
    this.createdAt,
  });

  TipsModel copyWith({
    String? id,
    String? doctor_name,
    String? health_tip,
    int? createdAt,
  }) {
    return TipsModel(
      id: id ?? this.id,
      doctor_name: doctor_name ?? this.doctor_name,
      health_tip: health_tip ?? this.health_tip,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'doctor_name': doctor_name,
      'health_tip': health_tip,
      'createdAt': createdAt,
    };
  }

  factory TipsModel.fromMap(Map<String, dynamic> map) {
    return TipsModel(
      id: map['id'] as String,
      doctor_name:
          map['doctor_name'] != null ? map['doctor_name'] as String : null,
      health_tip:
          map['health_tip'] != null ? map['health_tip'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TipsModel.fromJson(String source) =>
      TipsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TipsModel(id: $id, doctor_name: $doctor_name, health_tip: $health_tip, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant TipsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.doctor_name == doctor_name &&
        other.health_tip == health_tip &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        doctor_name.hashCode ^
        health_tip.hashCode ^
        createdAt.hashCode;
  }

  static List<Map<String, dynamic>> getTips() {
    return [
      {
        "doctor_name": "Dr. Amanda Collins",
        "datetime": "2023-06-21 09:00:00",
        "health_tip":
            "Stay hydrated by drinking enough water throughout the day."
      },
      {
        "doctor_name": "Dr. Benjamin Thompson",
        "datetime": "2023-06-21 10:30:00",
        "health_tip":
            "Eat a balanced diet consisting of fruits, vegetables, whole grains, and lean proteins."
      },
      {
        "doctor_name": "Dr. Sophia Anderson",
        "datetime": "2023-06-21 11:45:00",
        "health_tip":
            "Engage in regular physical activity for at least 30 minutes a day."
      },
      {
        "doctor_name": "Dr. Ethan Rodriguez",
        "datetime": "2023-06-21 13:15:00",
        "health_tip":
            "Get enough sleep to support your overall health and well-being."
      },
      {
        "doctor_name": "Dr. Olivia Patel",
        "datetime": "2023-06-21 14:45:00",
        "health_tip":
            "Practice stress management techniques like meditation or deep breathing exercises."
      },
      {
        "doctor_name": "Dr. Lucas Campbell",
        "datetime": "2023-06-21 16:00:00",
        "health_tip": "Avoid smoking and limit alcohol consumption."
      },
      {
        "doctor_name": "Dr. Lily Morgan",
        "datetime": "2023-06-21 17:30:00",
        "health_tip":
            "Take breaks from sitting for extended periods and incorporate movement into your daily routine."
      },
      {
        "doctor_name": "Dr. Jackson Turner",
        "datetime": "2023-06-21 18:45:00",
        "health_tip":
            "Protect your skin from the sun by using sunscreen and wearing protective clothing."
      },
      {
        "doctor_name": "Dr. Chloe Mitchell",
        "datetime": "2023-06-21 20:00:00",
        "health_tip":
            "Practice good hand hygiene by washing your hands frequently with soap and water."
      },
      {
        "doctor_name": "Dr. Daniel Lewis",
        "datetime": "2023-06-21 21:15:00",
        "health_tip":
            "Maintain a healthy weight through a combination of proper diet and regular exercise."
      },
      {
        "doctor_name": "Dr. Ava Wright",
        "datetime": "2023-06-21 22:30:00",
        "health_tip":
            "Limit your intake of saturated fats and opt for healthier fats like those found in avocados or nuts."
      },
      {
        "doctor_name": "Dr. Noah Reed",
        "datetime": "2023-06-22 09:00:00",
        "health_tip":
            "Schedule regular check-ups with your healthcare provider for preventive screenings and vaccinations."
      },
      {
        "doctor_name": "Dr. Mia Hill",
        "datetime": "2023-06-22 10:30:00",
        "health_tip":
            "Practice safe sex and use protection to prevent sexually transmitted infections."
      },
      {
        "doctor_name": "Dr. Gabriel Young",
        "datetime": "2023-06-22 11:45:00",
        "health_tip":
            "Avoid excessive sun exposure and tanning beds to reduce the risk of skin cancer."
      },
      {
        "doctor_name": "Dr. Harper Wright",
        "datetime": "2023-06-22 13:15:00",
        "health_tip":
            "Brush your teeth twice a day and floss daily to maintain good oral hygiene."
      },
      {
        "doctor_name": "Dr. Samuel Green",
        "datetime": "2023-06-22 14:45:00",
        "health_tip":
            "Engage in activities that stimulate your mind, such as reading, puzzles, or learning new skills."
      },
      {
        "doctor_name": "Dr. Emily Martinez",
        "datetime": "2023-06-22 16:00:00",
        "health_tip":
            "Limit your intake of sugary beverages and opt for water, herbal tea, or unsweetened drinks."
      },
      {
        "doctor_name": "Dr. Henry Ward",
        "datetime": "2023-06-22 17:30:00",
        "health_tip":
            "Incorporate strength training exercises into your fitness routine to build muscle and improve bone health."
      },
      {
        "doctor_name": "Dr. Victoria Baker",
        "datetime": "2023-06-22 18:45:00",
        "health_tip":
            "Practice portion control to maintain a healthy weight and prevent overeating."
      },
      {
        "doctor_name": "Dr. William Turner",
        "datetime": "2023-06-22 20:00:00",
        "health_tip":
            "Avoid excessive caffeine consumption, especially in the evening, as it can disrupt your sleep."
      },
      {
        "doctor_name": "Dr. Penelope Cooper",
        "datetime": "2023-06-22 21:15:00",
        "health_tip":
            "Practice mindful eating by paying attention to your food and savoring each bite."
      },
      {
        "doctor_name": "Dr. Andrew Bennett",
        "datetime": "2023-06-22 22:30:00",
        "health_tip":
            "Engage in regular cardiovascular exercise to strengthen your heart and improve circulation."
      },
      {
        "doctor_name": "Dr. Harper Wright",
        "datetime": "2023-06-23 09:00:00",
        "health_tip":
            "Limit your intake of processed meats, as they are linked to an increased risk of certain diseases."
      },
      {
        "doctor_name": "Dr. Ava Wright",
        "datetime": "2023-06-23 10:30:00",
        "health_tip":
            "Practice deep breathing exercises to reduce stress and promote relaxation."
      },
      {
        "doctor_name": "Dr. Daniel Lewis",
        "datetime": "2023-06-23 11:45:00",
        "health_tip": "Maintain good posture to prevent back and neck pain."
      },
      {
        "doctor_name": "Dr. Sophia Anderson",
        "datetime": "2023-06-23 13:15:00",
        "health_tip":
            "Limit your exposure to environmental toxins and pollutants."
      },
      {
        "doctor_name": "Dr. Lucas Campbell",
        "datetime": "2023-06-23 14:45:00",
        "health_tip":
            "Incorporate flexibility exercises into your routine to improve joint mobility and prevent injuries."
      },
      {
        "doctor_name": "Dr. Emily Martinez",
        "datetime": "2023-06-23 16:00:00",
        "health_tip":
            "Practice good hygiene by washing your hands before meals and after using the restroom."
      },
      {
        "doctor_name": "Dr. Samuel Green",
        "datetime": "2023-06-23 17:30:00",
        "health_tip":
            "Engage in activities that bring you joy and help you relax, such as hobbies or spending time in nature."
      },
      {
        "doctor_name": "Dr. Mia Hill",
        "datetime": "2023-06-23 18:45:00",
        "health_tip":
            "Avoid excessive salt intake and opt for herbs and spices to flavor your meals."
      },
      {
        "doctor_name": "Dr. Benjamin Thompson",
        "datetime": "2023-06-23 20:00:00",
        "health_tip":
            "Practice moderation in your alcohol consumption, if you choose to drink."
      },
      {
        "doctor_name": "Dr. Victoria Baker",
        "datetime": "2023-06-23 21:15:00",
        "health_tip":
            "Practice safe food handling and cooking techniques to prevent foodborne illnesses."
      },
      {
        "doctor_name": "Dr. William Turner",
        "datetime": "2023-06-23 22:30:00",
        "health_tip":
            "Limit your screen time and take regular breaks to rest your eyes and reduce eye strain."
      },
      {
        "doctor_name": "Dr. Ethan Rodriguez",
        "datetime": "2023-06-24 09:00:00",
        "health_tip":
            "Avoid prolonged exposure to loud noises or use ear protection in noisy environments."
      },
      {
        "doctor_name": "Dr. Lily Morgan",
        "datetime": "2023-06-24 10:30:00",
        "health_tip":
            "Incorporate low-impact exercises like swimming or cycling to reduce joint stress."
      },
      {
        "doctor_name": "Dr. Gabriel Young",
        "datetime": "2023-06-24 11:45:00",
        "health_tip":
            "Practice gratitude and positive thinking to improve your mental well-being."
      },
      {
        "doctor_name": "Dr. Chloe Mitchell",
        "datetime": "2023-06-24 13:15:00",
        "health_tip":
            "Limit processed sugar intake and opt for natural sweeteners like honey or maple syrup."
      },
      {
        "doctor_name": "Dr. Noah Reed",
        "datetime": "2023-06-24 14:45:00",
        "health_tip":
            "Take regular breaks from electronic devices and engage in activities that promote relaxation."
      },
      {
        "doctor_name": "Dr. Amanda Collins",
        "datetime": "2023-06-24 16:00:00",
        "health_tip":
            "Avoid excessive use of over-the-counter medications and consult a healthcare professional if needed."
      },
      {
        "doctor_name": "Dr. Harper Wright",
        "datetime": "2023-06-24 17:30:00",
        "health_tip":
            "Spend time outdoors and soak up natural sunlight for vitamin D synthesis."
      },
      {
        "doctor_name": "Dr. Daniel Lewis",
        "datetime": "2023-06-24 18:45:00",
        "health_tip":
            "Limit your intake of artificial additives, preservatives, and food colorings."
      },
      {
        "doctor_name": "Dr. Olivia Patel",
        "datetime": "2023-06-24 20:00:00",
        "health_tip":
            "Practice safe lifting techniques to prevent back injuries."
      },
      {
        "doctor_name": "Dr. Benjamin Thompson",
        "datetime": "2023-06-24 21:15:00",
        "health_tip":
            "Engage in activities that challenge your brain, such as puzzles, memory games, or learning new languages."
      },
      {
        "doctor_name": "Dr. Ava Wright",
        "datetime": "2023-06-24 22:30:00",
        "health_tip":
            "Practice proper hygiene when using public spaces, such as gyms or public transportation."
      }
    ];
  }
}
