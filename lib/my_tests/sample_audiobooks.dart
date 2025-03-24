import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wajanja/data_layer/models/audiobook/audiobook.dart';
import 'package:wajanja/data_layer/models/audiobook/audiobook_chapter.dart';

final audiobooks = [
  Audiobook(
    coverphoto:
        "https://images.squarespace-cdn.com/content/62ee877c651e985f581200ae/1662861610842-7K1VJI1G82TQL5Z0XN3L/Hobbit+Ch+1+YOUTUBE+thumb+copy.png?format=1500w&content-type=image%2Fpng",
    postedBy: "ugochukwugospel001@gmail.com",
    title: "THE HOBBIT",
    averageRating: 0.0,
    createdAt: Timestamp.fromDate(DateTime.now()),
    likes: [],
    dislikes: [],
    description:
        """A great fantasy classic by J.R.R. Tolkien and the prelude to "The Lord of the Rings,"  our protagonist Bilbo Baggins is a Hobbit who enjoys a quiet and comfortable life, never traveling any farther than his own kitchen. But his contentment is disturbed when the Wizard Gandalf and a company of Dwarves arrive at his Hobbit home one day to take him away on an adventure. They have launched a plot to attack the treasure guarded by Smaug the Magnificent, a large and very dangerous dragon. Bilbo reluctantly joins their quest, not knowing that on his journey to the Lonely Mountain he will encounter both a magic ring and a frightening creature known as Gollum.

Um grande clássico da fantasia de J.R.R. Tolkien e o prelúdio de "O Senhor dos Anéis," nosso protagonista Bilbo Bolseiro é um Hobbit que desfruta de uma vida tranquila e confortável, nunca viajando além de sua própria cozinha. Mas seu contentamento é perturbado quando o Mago Gandalf e uma companhia de Anões chegam à sua toca de Hobbit um dia para levá-lo em uma aventura. Eles lançaram um plano para atacar o tesouro guardado por Smaug, o Magnífico, um dragão grande e muito perigoso. Bilbo relutantemente se junta à busca deles, sem saber que em sua jornada para a Montanha Solitária ele encontrará um anel mágico e uma criatura assustadora conhecida como Gollum.""",
    chapters: [
      AudiobookChapter(
        title:
            "THE HOBBIT Chapter 1 - For Beginners, Learn English Through Reading / em inglês para iniciantes",
        url:
            "https://res.cloudinary.com/extelvogroup/video/upload/v1742748892/wajanja_tv/audiobooks/THE_HOBBIT_Chapter_1_-_For_Beginners_Learn_English_Through_Reading_os3qjv.mp3",
        duration: 763,
      ),
      AudiobookChapter(
        title:
            "THE HOBBIT Chapter 2- For Beginners, Learn English with Reading / inglês para iniciantes",
        url:
            "https://res.cloudinary.com/extelvogroup/video/upload/v1742749248/wajanja_tv/audiobooks/THE_HOBBIT_Chapter_2-_For_Beginners_Learn_English_with_Reading___ingle%CC%82s_para_iniciantes_roiobl.mp3",
        duration: 1672,
      ),
      AudiobookChapter(
        title:
            "THE HOBBIT Chapter 3 - For Beginners, Learn English with Reading / inglês para iniciantes",
        url:
            "https://res.cloudinary.com/extelvogroup/video/upload/v1742749978/wajanja_tv/audiobooks/THE_HOBBIT_Chapter_3_-_For_Beginners_Learn_English_with_Reading___ingle%CC%82s_para_iniciantes_zvptrt.mp3",
        duration: 1463,
      ),
    ],
  ),
];
