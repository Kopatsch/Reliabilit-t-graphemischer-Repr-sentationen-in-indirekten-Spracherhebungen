# Reliabilität graphemischer Repräsentationen in indirekten Spracherhebungen

Die zwei indirekten Spracherhebungen, die hier verglichen werden, sind die von Walter Mitzka 1938/39 (DWA) und Friedrich Maurer 1941.

## DWA
"Noch während der Arbeit an den Karten für den gedruckten DSA war ein neues Projekt entstanden: der Deutsche Wortatlas, unter der Leitung von Walter Mitzka, dessen Datenerhebung analog zum Sprachatlas 1938/39 indirekt durchgeführt wurde. Er umfasst 200 Wörter, war also immer noch im Vergleich zu den romanischen Atlanten sehr sparsam, Kriterien oder ein System für die Auswahl der Wörter sind nicht offensichtlich. Die Karten wurden in 22 Bänden von 1956 bis 1980 publiziert (Mitzka 1956-1980) sowie in einer Reihe von Dissertationen kommentiert und ausgewertet, wobei versucht wurde, sämtliche Variationen und Formen in den Antwortbögen in umfangreichen kartenbegleitenden Listen zu berücksichtigen. Damit war auch dieses Projket abgeschlossen, die zusammen über 90.000 Antwortbögen lagerten im Institut des FIDS-DSA, das als Forschungsinstitut an der Universität Marburg weitergeführt wurde. Im Institut selbst, aber auch an anderen Institutionen entstanden im Laufe der Zeit eine Reihe von Regionalatlanten, die hier nicht interessieren sollen." (Stein 93)

Stein, Peter. "Die Wiederbelebung der Wenkersätze." *Grazer Linguistische Studien*, Ausg. 86, 2016, S. 85-103.

"1993 wird Walther Mitzka (1888-1976) als Nachfolger Ferdinand Wredes, der 1929 in den Ruhestand getreten war, zum Direktor des Instituts berufen, das fortan in Anlehnung an den in Umsetzung begriffenen Printatlas den Namen "Deutscher Sprachatlas" (DSA) führt." (DSA Homepage)

"1938 beginnt Mitzka mit der Datensammlung zum "Deutschen Wortatlas" (DWA). Wiederum werden aus fast 50.000 Orten des deutschsprachigen Mitteleuropas (ohne die Schweiz) Daten zusammengetragen. Der Deutsche Wortatlas erscheint zwischen 1951 und 1980 in insgesamt 22 Bänden." (DSA Homepage)

DSA Homepage https://www.uni-marburg.de/de/fb09/dsa/einrichtung/institutsgeschichte


## Maurer
"1941 versandte Friedrich Maurer einen Dialektfragebogen an alle Schulorte im damaligen Gau Baden-Elsass. Dieses Gebiet schließt den niederalemannischen Sprachraum sowie die badischen und elsässischen Teile des Hoch- und Mittelalemannischen und fränkische Übergangsgebiete ein (vgl. Wiesinger 1983a). Während die Erhebung Georg Wenkers in eine Ziet fällt, in der es zwar bereits Bestrebungen zur Normierung der Aussprache des Standards gab, diese sich aber noch nicht im gesamten Sprachraum durchgesetzt hatten, kann davon ausgegangen werden, dass die Standardisierung 1941 besonders duch die Einführung des Rundfunks in den 30er Jahren deutlich weiter fortgeschritten war und die befragten LehrerInnen über gute Kenntnisse der gesprochenen Standardsprache verfügten." (Strobel 157)

"Im Jahr 1941 führte Friedrich Maurer eine indirekte Dialekterhebung in Baden und im Elsass durch. Der Fragebogen, der insgesamt 110 Übersetzungsfragen umfasst, bei denen ein standardsprachlicher Begriff oder Satz (insgesamt 7 Sätze) in den Ortsdialekt übersetzt werden sollte, wurde an alle Schulen im Gebiet verschickt, wo meist Lehrer als Informanten oder Zwischenexploratoren, indem sie SchülerInnen oder andere Ortsansässige befragten, dienten. Zu 43% wurden die Fragebögen von LehrerInnen alleine und zu 14% von SchülerInnen oder Schulklassen ohne (genannte) Erwachsene beantwortet. Dabei wurden auch relativ umfangreiche Sozialdaten erhoben - neben dem Beruf und dem Alter der Beantwortenden auch der Geburtsort und die Geburtorte der Elternteile -, sowie Angaben zur Ortsmobilität("Wohin fährt man zum Einkaufen?", "Wohin gehen die Arbeiter zum Arbeitn?") und Volkskundliches erfragt. Erste Ergebnisse der Befragung wurden ihrerzeit in 13 Karten in Maurer(1942) publiziert und die insgesamt fast 2500 Fragebögen dann 2017 an der Albert-Ludwigs-Universität Freiburg wiederentdeckt." (Strobel 159)

"Das Untersuchungsgebiet für diesen Beitrag umfasst das Oberrheingebiet mit dem gesamten Elsass sowie das angrenzende Baden mit den Landkreisen Karls ruhe (Süd), Rastatt, BadenBaden, Ortenaukreis, Emmendingen, Stadtkreis Freiburg i. Br., BreisgauHochschwarzwald, Lörrach und Waldshut. Der Rhein verläuft somit am südöstlichen Rand und dann mittig durch das Untersuchungs gebiet nach Norden. Für das Gebiet liegen neben dem Wenkeratlas und der Erhebung Maurers auch zwei direkt erhobene Regionalatlanten aus der zweiten Hälfte des 20. Jahr hunderts vor: Der „Atlas linguistique et ethnografique de l’Alsace“ (ALA I und ALA II) und der „Südwestdeutsche Sprachatlas“ (SSA)." (Strobel 160)

Strobel, Maj-Brit. "Die Verschriftlichungen in der Dialekterhebung Friedrich Maurers in Baden und im Elsass als Evidenz für die Verbreitung der Standardlautung." ZGL, Ausg. 49, Nr. 1, de Gruyter, 2012, S. 155-188, https://doi.org/10.1515/zgl-2021-2024.


## Levenshtein

Levenshtein Original: https://bibbase.org/network/publication/levenshtein-binarycodescapableofcorrectingdeletionsinsertionsandreversals-1966

Lameli Methoden Paper: https://aclanthology.org/2023.vardial-1.13.pdf


"A disadvantage of the frequency per word method is that this method is not sensitive to the order of phonetic segments in a word. The better alternative for finding word distances is to use the Levenshtein distance, which considers for each word its sequential structure. In 1995 Kessler introduced the use of the Levenshtein distance as a tool for measuring dialect distances (Kessler, 1995). He applied it successfully to Irish Gaelic. The Levenshtein distance is a numerical value of the cost of the least expensive set of insertions, deletions or substitutions that would be needed to tramsform one string into another (Kruskal, 1999). The simplest technique is phone string comparison. In this approach all operations have the same cost, e.g., 1. In Kessler's approach when two phones are basically equal but have different diacritics, they are regarded as different phones. [...] In the above technique it is not possible to take into account the affinity between pones that are not equal, but are still related. [...] This problem can be solved by replacing each phone by a bundle of features, just as in the feature frequency method. A feature bundle is a range of feature values. [...] Since diacritics influence feature values, they likewise figure in the mapping from transcriptions to feature bundles, and thus automatically figure in calculations of phonetic distance. The resulting metric is called *feature string comparison*. Using the *phone string comparison* Kessler calculated Levenshtein distances not only when words are phonetic variants of each other, but also when they lexically differ. He called this the *all-word* approach. However, when he used the *feature string comparison*, not only the *all-word* approach was used, but also an approach was used in which the Levenshtein distance is only applied when words are phonetic variants of each other. Kessler called this approach the *same-word* approach." (Heeringa 22f.)

"Following Kessler (1995) we used the Levenshtein distance for finding distances between dialects and for finding dialect classifications which are based on the dialect distances. Compared to other methods mentioned in this chapter, the use of the Levenshtein distances has abvious advantages. The Levenshtein distance is completely objective, and its results are verifiable, an advantage it shares with other computational methods, in contrast to dialect maps based on tribes and intuition (see Section 2.1.1). However, a condition for using Levenshtein is that the data used consists of representative samples of the varieties. Using the isogloss method, isoglosses cannot simply be added. They are selected so that satisfactory boundaries emerge [...], which make [sic.] this method subjective. However, the LEvenshtein distance and other computational methods are able to add differences. This allows one to relate entire varieties, aggregating the atomic differences. None of the differences need to be excluded. [...] The arrow method, as an attempt to process subjective impressions in a [sic.] objective way (Goossens, 1977), has the shortcoming that only relations between adjacent varieties can be found. [...] However, when using the LEvenshtein distance or other computational methods, such comparisons can easily be made. [...] For a listener in a perception experiemnt it may be much harder to judge the distance between two unknown varieties. However, with the Levenshtein distance and other computational methods the distance for any pair of varieties can be found. [...] Using Levenshtein, gradual distances between words are found. Lexical, phonological and morphological differences need not be explicitly distinguished, but can be processed with the same algorithm. However, since the algorithm compares word pronunciations, syntactic differences are not processed. [...] Using the corpus frequency method or frequency per word method no difference between these two pronunciations is found. However, when using the Levenshtein distance, the order of segments is taken into account. We conclude that the Levenshtein distance is superior to traditional methods because of its objectivity and sensitivity. Furthermore, the Levenshtein distance does not have the limitation of perceptually-based methods. Compared to previous computational methods, with the Levenshtein distance the data is used most exhaustively. This makes the LEvenshtein distance most sensitive." (Heeringa 24ff.)

"In transcriptions words are transcribed as a series of speech segments: phones. In the simplest case the phones are not further defined." (Heeringa 28)

"Both the length and the correspondence problem are solved when using the *Levenshtein distance*. This algorithm is able to deal with different lengths calculating the distance on the basis of probable correspondences. Although Levenshtein applied his algorithm to error control of codes which are transfered by e.g., radio or telegraph, the algorithm may be applied to all cases mentioned at the beginning of this section. [...] The Levenshtein distance was first applied by Kessler (1995) to dialect comparison. He used the algorithm for the comparison of Irish Gaelic varieties." (Heeringa 122 f.)

"Fundamental to the idea of the Levenshtein distance is the notion of string-changing operations. To determine the extent to which two strings differ from each other, an inventory of what operations can change into another should be made. The operations available are:
* Deletions
Delete an element from the string.
* Substitutions
Replace an element from the one string by an element of the other string.
* Insertions
Add an element to the string." (Heeringa 123)

"The Levenshtein distance calculates the cost of changing one sequence or string into another. It determines how the one sequence or string can be changed into the other in the easiest way by inserting, deleting or substituting elements." (Heerings 142)

"Furthermore, the Levenshtein distance is symmetric. This means that the distance between word 1 and word 2 is equal to the distance between word 2 and word 1." (Heeringa 145)

Heeringa, Wilbert Jan. *Measuring Dialect Pronunciation Differences using Levenshtein Distance*. Groningen, 2004.


"Measuring the similarity between text strings is a fundamental problem in computer science, and has applications in bioinformatics[...], databases[...], and natural language processing[...]. Among the measures of similarities between strings, the Levenshtein distance [...] is the most commonly used, both for its practicality and its ease of computation. The distance quantifies the minimum number of operations of insertion, deletion and substitution needed to transform a string into another one. Is has a wide range of applications, ranging from biological sequence alignment [...] to dialect pronunciation differences [...] or signature authentication [...]." (Bourhis et al. 16:2)

"However, a limitation of the Levenshtein distance is that it only captures proximity between strings (or objects) written on the same alphabet. Evaluating the proximity of strings written on different alphabets is a problem that arises in various applications, such as bioinformatics [...], image processing [...] and code duplication [...]." (Bourhis et al. 16:2)

Pierre Bourhis, Aaron Boussidan, Philippe Gambette. On Distances between Words with Pa-
rameters. CPM 2023, Jun 2023, Champs-sur-Marne, Marne-la-Vallée, France. pp.6:1-6:23,
10.4230/LIPIcs.CPM.2023.6. hal-04080842
https://hal.science/hal-04080842/document


"Levenstein distance, developed by Vladimir Levenstein in (1966), is a measure of proximity between two strings. Is is mainly applied to compare sequences in linguistics domain such as plagiarism detection and speech recognition; in molecular biology for comparing sequences of macro molecules, etc.
Levenstein distance calculates least expensive set of *insertions*, *deletions* or *substitutions* that are required to transform one string into another. For example, if we have to compare two strings such as "MONDAY' and 'SATURDAY', one of the optimum ways is to insert the letters "S" and "A" and substitute "M", "O" and "N" with "T", "U" and "R", respectively leading towards a generalised Levenstein distance (GLD) of 5 (assuming a unit distance for each operation) as shown in Fig.2." 

To understand the GLD technique and its formulation, let’s say, **X** represents any string expressed as **X** = (x1..xi..xq) where xi is the ith character of **X**. The substring of **X** is represented as **X**i..j that includes characters from xi to xj where 1 ≤ i ≤ j ≤ q. The length of **X** i..j is expressed as |**X** i..j| and is computed using Equation (10).

|**X** i..j| = j-i+1 (10)

A null string, with no character, is expressed as ε (with |e| = 0). Any general edit operation for a pair of characters (a, b) is expressed as a -> b where a and b are from separate strings.

If string **X** is the result of the operation a -> b to string **Y**, then it can be written as **Y** => **X** via a -> b. The notations for the three operations are expressed as follows:

(1) *Insertion*: if e -> a;
(2) *Deletion*: if b -> e; and
(3) *Substitution*: if a-> b; a != e and b != e

Let’s define **S** = (S0, S1,..Sk...Ss) as the sequence of edit operations to transform **Y** => **X** and then the cost associated with each edit operation as ß =(ß0,ß1..ßk..ßs). GLD is the minimum total cost required to transform **Y** to **X** as shown in Eq. (11).

GLD (**Y**, **X**) = min ()   (11)

The normalised Levenshtein distance (NLD) is the GLD normalised by the sum of the lengths of two strings (Eq. (12)). This measure always lies between 0 and 1 (Yujian and Bo, 2007).

NLD (**Y**; **X**) =           (12)

Heeringa (2004) developed a pseudo code for computing GLD and NLD for comparing two strings. The *Algorithm 1* shown in Table 1 demonstrates the comparison between the strings, **X** and **Y**. Here **X** = (x1…xq) and **Y** = (y1…yp). The lengths of strings i.e. **|X|** and **|Y|** are q and p, respectively.

Table 1. Algorithm 1 demonstrating computation of the Levenshtein distance for strings comparison.

Create an empty matrix “K” of size (p + 1) * (q + 1) where the row and column headers correspond to characters of the string Y and X, respectively.
Assign values [0..q] and [0..p] to the first row and first column, respectively
for j = 1 to q
for i = 1 to p
Estimate cost as
Set the cell K(i,j) = min (K(i − 1,j) + 1, K(i,j − 1) + 1, K(i − 1,j − 1) + Ci,j) where:
K(i − 1,j) + 1 represents the cell value immediately above the current cell plus 1
K(i,j − 1) + 1 represents the cell value immediately to the left of current cell plus 1
K(i − 1,j − 1) + 
represents the cell value immediately in diagonal above and to the left of current cell plus the cost
The GLD is the value of the cell K(p + 1, q + 1) and the NLD =

The above pseudo code is explained with the help of an example presented in Fig. 3. Here, the matrix, K, of size (p + 1) * (q + 1) is defined to compare the strings Y (size p) and X (size q). The numbering of rows and columns of the matrix K commence with 0 (K(1,1)), and the values [0..q] and [0..p] are assigned to the first row and first column, respectively (see grey shaded column and row in Fig. 3). This is done to facilitate the comparison of the first character from both strings X and Y. The comparison is made by traversing the matrix row by row, and then column wise until all characters in both strings are compared. Since, the overall comparison of all characters ends at the last cell of the matrix, K(p + 1, q + 1) is chosen as GLD value.

The presented arrows in Fig. 3 illustrates one possible path to reach to the cell K(p + 1,q + 1). There are multiple paths (i.e. different combination of arrows) possible to arrive at the final K(p + 1,q + 1). Each path is a combination of editing operations represented as the following moves on the matrix grid: downward movement along the diagonal is for substitution operations, eastward movement is for deletion operation, and vertical downward movement is for insertion operation (Oliveira-Neto et al., 2012).

In literature, the use of Levenshtein distance for transport applications is relatively scarce. Oliveira-Neto et al. (2012), for instance, applied this technique to compare license plates. Here, the sequence of characters on the license plates observed at upstream and downstream stations were compared. Zhang et al. (2018) applied Levenshtein technique to compare the sequences of trip purposes and cluster activity-travel patterns. Markou et al. (2019) used Levenshtein distance as one of the algorithms to compare time series spatiotemporal event data from the internet and predict taxi demand hotspots. Other researchers have used similar techniques (such as sequence alignment method (SAM)) to compare any two activity-travel patterns (as by Allahviranloo and Recker, 2015); and sequence of trips (as by Crawford et al., 2018). The commonality among these studies is that they were similar to comparison of one-dimensional strings with unit cost for each operation. However, OD matrices are two-dimensional arrays consisting of OD flows between different origin and destination pairs, which means direct application of such traditional techniques is not possible. In light of this, the following section proposes a methodology to extend the applicability of traditional Levenshtein distance for the structural comparison of OD matrices. (Behara et al. 517 f.)

Behara, Krishna N.S., Bhaskar, Ashish, and Edward Chung. "A novel approach for the structural comparison of origin-destination matrices: Levenshtein distance." Transportation Research Part C: Emerging Technologies, Ausg. 111, 2020, S. 513-530, https://www.sciencedirect.com/science/article/pii/S0968090X19307053?via%3Dihub.


## Reliabilität

"Mangelnde instrumentelle Reliabilität ("instrumentation"): Im Verlaufe der Zeit kann sich die Qualität eines Messinstrumentes verändern, so dass Messwertunterschiede entstehen, die fälschlich als kausale Treatmentwirkung interpretiert werden können. Bei einer Datenerhebung mittels Beobachtung kann es z.B. durch Konzentrationsschwankungen oder Voreingenommenheiten der Beobachter zu Veränderungen in den Messwerten kommen. Als Gegenmaßnahme sind standardisierte Messinstrumente mit hoher Reliabilität zu nutzen und z.B: nur geschulte Beobachter für jeweils kurze Beobachtungsspannen erinzusetzen" (Döring, Bortz 103)

Döring, Nicola, Bortz, Jürgen. Forschungsmethoden und Evaluation in den Sozial- und Humanwissenschaften, Springer, 2016.

"Die statistische Beziehung zwischen zwei parallelen Formen eines Tests wird als Reliabilität bezeichnet." (Weiss 316)
"Von parallelen Tests, von Test und Retest und von Test-Retest-Reliabilität spricht man in der Regel, wenn die Tests unmittelbar oder rasch hintereinander erfolgen." (Weiss 316)

Weiss, Volkmar. "Reliabilität, Heritabilität und Längsschnittkorrelation." Ärztliche Jugendkunde, Ausg. 69, Nr. 5, ResearchGate, 1978, S. 314-319.


"In den Sozialwissenschaften werden häufig Unterschiede zwischen Personen gemessen. [...] Die Reliabilität beschreibt die Genauigkeit einer solchen Messung. Formal betrachtet entspricht der Reliabilitätskoeffizient R dem Verhältnis zwischen wahren Unterschieden t und beobachteten Unterschieden Y." (Danner 1)

Danner, Daniel. "Reliabilität - die Genauigkeit einer Messung." GESIS survey Guidelines, Leibnitz-Institut für Sozialwissenschaften, 2015, https://www.gesis.org/fileadmin/admin/Dateikatalog/pdf/guidelines/reliabilitaet_danner_2015.pdf.