---
title: "My Depression Report"
author: "My Depression Application"
date: 
Date:  Tue Jul 04 1:05:25 AM 2017
output: html_document
---
<style> body{ font-family: 'Oxygen', sans-serif; font-size: 16px; line-height: 24px; } h1,h2,h3,h4 { font-family: 'Raleway', sans-serif; } .container { width: 1000px; } h3 { background-color: #D4DAEC; text-indent: 100px; } h4 { text-indent: 100px; } g-table-intro h4 { text-indent: 0px; } </style>

Date:  Tue Jul 04 1:05:25 AM 2017
### STEP1: Depression scores

Here is how you assessed  severity of each symptom in the first questionnaire: 

|                    |Score |
|:-------------------|:-----|
|Little Interest     |2     |
|Feeling Down        |2     |
|Sleep Issues        |2     |
|Fatigue             |2     |
|Appetite Change     |2     |
|Worthlessness       |2     |
|Trouble Concentrate |1     |
|Slow/Fidgety        |1     |
|Suicidality         |2     |

Based on the abobe-mentioned scores your total score is 16 ,which translates to a severity of Moderately severe.This questionnaire suggests the following course of action for this degree of severity to the care provider: Warrants active treatment with psychotherapy, medications, or combination
### STEP2: Causality Matrix
In the second step, you supplied the following causality matrix:


| Little Interest | Feeling Down | Sleep Issues | Fatigue | Appetite Change | Worthlessness | Trouble Concentrate | Slow/Fidgety | Suicidality |
|:---------------:|:------------:|:------------:|:-------:|:---------------:|:-------------:|:-------------------:|:------------:|:-----------:|
|        0        |      0       |      0       |    0    |        0        |       0       |          0          |      0       |      0      |
|        1        |      0       |      0       |    0    |        0        |       0       |          0          |      0       |      0      |
|        0        |      0       |      0       |    0    |        0        |       0       |          0          |      0       |      0      |
|        0        |      0       |      0       |    0    |        0        |       1       |          0          |      0       |      0      |
|        0        |      0       |      0       |    0    |        0        |       0       |          0          |      0       |      0      |
|        0        |      0       |      1       |    0    |        0        |       0       |          0          |      0       |      0      |
|        0        |      0       |      0       |    0    |        0        |       0       |          0          |      0       |      0      |
|        0        |      0       |      0       |    0    |        0        |       0       |          0          |      0       |      0      |
|        1        |      0       |      0       |    0    |        0        |       0       |          0          |      0       |      0      |

### Step3: Your Depression Network Graph

Based on this causality matrix the following graph was built to visually present interplay of your symptoms of depression.

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png)

## Explanation About the Graph

In this graph symptoms are represented by circles which are also called "nodes". The 
relationship between them are represented by arrows. So for example a->b means symptom a
contributes to worsening of symptom b. 

The score of each symptom is represented by the shade of its color so for example if you scored a symptom as happening "Nearly every day" in stage 1, its color is deep red and if a symptom is scored as "Not at all", it has no color and only shows the color of the background which is green. The size of a node reflects its "Centricity" in the graph. The software assigns a more central position to symptoms that are more prominent in terms of relations to other symptoms in the graph. In other terms symptoms that are bigger in size play a  more central role in your depression, hence, if targeted by treatment(either medication or psychotherapy) have a deeper impact in reducing the overall severity of the depression. 

In network analysis which is the statistical method used in computing this graph, multiple measures of centricity are calculated for each symptom. One of them is Outdegree, which is the number of arrows which originate from a node. If a symptom that contribute to worsening of many other symptoms in the graph is targeted and gets improved, the overall improvement in severity of depression would be more prominant. Here is a table ordered by the outdegree of each symptom of your depression.

|    |       Symptom       | Outdegree |
|:---|:-------------------:|:---------:|
|LtI |   Little Interest   |     0     |
|SlI |    Sleep Issues     |     0     |
|ApC |   Appetite Change   |     0     |
|TrC | Trouble Concentrate |     0     |
|S/F |    Slow/Fidgety     |     0     |
|FlD |    Feeling Down     |     1     |
|Ftg |       Fatigue       |     1     |
|Wrt |    Worthlessness    |     1     |
|Scd |     Suicidality     |     1     |

Different medications and psychotherapy techniques usually target multiple symptoms but each treatment modality is more effective against one or a few symptoms. Using the data above you can discuss with your provider to start new medications, change the dose of current medication used against the symptom or add medications or therapies which are more effective against the more central symptoms.

We suggest repeating the analysis periodically to monitor the effecacy of treatment in lowering the score of more central symptoms, their centricity and the total score and severity of the depression.
