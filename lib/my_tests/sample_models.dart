import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/data_layer/models/videos/video.dart';
import 'package:wajanja/utils/constants/enums.dart';
// import 'package:wajanja/models/video.dart';

final videos = [
  Video(
    title: "Sonic the Hedgehog 3",
    description:
        "Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.",
    coverPhotoPortrait:
        "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcT-Qugxbvit45lDp8DpN0WLe39oloNTslJLai2_mQ9GYFMQ28mrpiJxNUXr9dZSLDcw7BD8GA",
    postedBy: User(email: "ugochukwugospel001@gmail.com"),
    // url: null,
    youtubeUrl: "https://youtu.be/bvrNZejEWzA?si=e05R6QM2_pdDwXZo",
    // vimeoUrl: null,
    category: VideoCategories.entertainment,
    likes: [],
    dislikes: [],
    country: "NG",
    city: "Owerri",
    createdAt: Timestamp.fromDate(DateTime(2024, 3, 10)),
  ),
  Video(
    title: "There's more to those colliding blocks that compute pi",
    description:
        "Two colliding blocks compute pi, here we dig into the physics to explain why Instead of sponsored ad reads, these lessons are funded directly by viewers: https://3b1b.co/support An equally valuable form of support is to simply share the videos.",
    // coverPhotoPortrait: "https://i.ytimg.com/vi/6dTyOl1fmDo/maxresdefault.jpg",
    postedBy: User(email: "ugochukwugospel001@gmail.com"),
    // url: null,
    youtubeUrl: "https://youtu.be/6dTyOl1fmDo?si=G8Viyuk6_SdlqSzu",
    // vimeoUrl: null,
    category: VideoCategories.education,
    likes: [],
    dislikes: [],
    country: "NG",
    city: "Owerri",
    createdAt: Timestamp.fromDate(DateTime(2024, 3, 10)),
  ),
  Video(
    title: "The Lady of Heaven",
    description: """Name: Lady of Heaven
Genres: Action, Drama, History
In a world fractured by conflict, the timeless lessons of resilience and faith shine through in a tale that bridges centuries. The story follows a young Iraqi boy, orphaned amidst the chaos of war, as he embarks on a journey of understanding. His path crosses with the profound and tragic history of a revered figure from 1400 years ago—a woman who faced immense suffering yet exemplified unwavering strength and patience.

Through the boy's eyes, the audience is drawn into a vivid narrative that connects past and present, weaving together themes of perseverance, hope, and the enduring impact of moral courage. As the historical struggles unfold, their echoes resonate deeply in the modern world, highlighting humanity’s capacity to overcome despair with compassion and faith. This cinematic experience is a powerful reflection on how ancient wisdom can guide us through contemporary strife, offering a beacon of light in the darkest of times.

"Welcome to the 'Movie Marathon' channel — your reliable guide to the world of captivating cinematic adventures! We specialize in showcasing full-length films of various genres to cater to even the most discerning tastes of movie enthusiasts..""",
    coverPhotoPortrait: "https://i.ytimg.com/vi/bc9q__VbYL4/mqdefault.jpg",
    postedBy: User(email: "ugochukwugospel001@gmail.com"),
    // url: null,
    youtubeUrl: "https://youtu.be/bc9q__VbYL4?si=9rrF87Td-_7txT5g",
    // vimeoUrl: null,
    category: VideoCategories.entertainment,
    likes: [],
    dislikes: [],
    country: "NG",
    city: "Owerri",
    createdAt: Timestamp.fromDate(DateTime(2024, 3, 10)),
  ),
  // Video(
  //   title: "Dark Secrets of Vatican City - Forbidden History",
  //   description:
  //       """Dive into the secretive world of the Vatican. From hidden archives and alleged Nazi collaboration to the mysteries of the Vatican Bank and its advanced observatory. Discover the untold stories that shape the Catholic Church's controversial history.""",
  //   coverPhotoPortrait: "https://i.ytimg.com/vi/zI0SvaIV6c4/maxresdefault.jpg",
  //   postedBy: User(email: "ugochukwugospel001@gmail.com"),
  //   // url: null,
  //   youtubeUrl: "https://youtu.be/AV2LpVplmgc?si=OrqlMwNQwUuNaLi9",
  //   // vimeoUrl: null,
  //   category: VideoCategories.scienceAndDocumentary,
  //   likes: [],
  //   dislikes: [],
  //   country: "NG",
  //   city: "Owerri",
  //   createdAt: Timestamp.fromDate(DateTime(2024, 3, 10)),
  // ),
  Video(
    title: "The UnXplained: Egypt's Most SHOCKING Hidden Secrets",
    description:
        """These Egyptian secrets will shock you to the core. See more in this compilation from The UnXplained. 

Watch all new episodes of The UnXplained, Fridays at 9/8c, and stay up to date on all of your favorite The HISTORY Channel shows""",
    coverPhotoPortrait:
        "https://i.ytimg.com/vi/3YNH6hf-1hk/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLC-bVNoRBp86R69zdvnSD9ERZGSpQ",
    postedBy: User(email: "ugochukwugospel001@gmail.com"),
    // url: null,
    youtubeUrl: "https://youtu.be/PIxe19xS_18?si=TZ-5g70Z7FfrWtz8",
    // vimeoUrl: null,
    category: VideoCategories.scienceAndDocumentary,
    likes: [],
    dislikes: [],
    country: "NG",
    city: "Owerri",
    createdAt: Timestamp.fromDate(DateTime(2024, 3, 10)),
  ),
  Video(
    title:
        "Master Enum Serialization in Flutter | Complete Guide for JSON and API Handling",
    description:
        """Learn how to efficiently serialize Enums in Flutter in this step-by-step tutorial! Whether you're working with JSON, APIs, or building a dynamic Flutter app, understanding Enum serialization is key to managing your data effectively. 

In this video, we’ll look at how to serialize and deserialize Enums.

🔗 Resources:
Official Flutter Enum Documentation: https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqay13WVVPT25PdWZ5d3lwRmlEV25IdUJqWWlnUXxBQ3Jtc0tuTDdvV1V0c1ZibDBYNkI3SXJRNG1lN1hTQXNMR0dhTU1salhkMUVfWHJOSTlPbXVYZnBIOHNZaEVnemJMQWRhTVRMbnJUOExCN3V0ZXBOSGJIX1Y4M0pWeGU0OFRfaXpvQzdVTTJsbTh4enRFaTcwZw&q=https%3A%2F%2Fapi.flutter.dev%2Fflutter%2Fdart-core%2FEnum-class.html&v=_CbfvtSndhI

Make sure to like, comment, and subscribe for more Flutter development tips and tutorials.""",
    // coverPhotoPortrait:
    //     "https://i.ytimg.com/vi/3YNH6hf-1hk/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLC-bVNoRBp86R69zdvnSD9ERZGSpQ",
    postedBy: User(email: "ugochukwugospel001@gmail.com"),
    // url: null,
    youtubeUrl: "https://youtu.be/_CbfvtSndhI?si=ls1OctGZGBjzCjsP",
    // vimeoUrl: null,
    category: VideoCategories.education,
    likes: [],
    dislikes: [],
    country: "NG",
    city: "Owerri",
    createdAt: Timestamp.fromDate(DateTime(2024, 3, 10)),
  ),
];
