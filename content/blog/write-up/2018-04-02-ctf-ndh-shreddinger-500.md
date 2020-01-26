---
title: "[CTF] NDH - Schreddinger"
description: "Write-up for challenge 'Schreddinger' (Dev, 500 pts) from NDH Quals 2018."
tags: [ "CTF", "Python", "OCR", "PIL" ]
lastmod: 2018-04-03 20:12:54
date: "2018-04-02 21:34:07"
categories:
    - "Write-up"
type: post
slug: "ctf-ndh-shreddinger-500"
cover: "/media/2018/04/6fb3c199d45b68d1822f1a9ba3e315db.png"
---

> The infamous Shredder tried to destroy important documents!
> Please, help us recover them and prevents their evil scheme.
>   
> Points      500  
> Category    Dev  
> Validation  11  
> URL         http://shreddinger.challs.malice.fr/

<!--more-->

The given URL leads to a form asking for the shredded token. We learn that we have 10 seconds to solve the challenge and a link allows us to download a ZIP file containing an image shredded into 100 pieces of 10x1400 pixels. The pieces are mixed and some of them are upside down. We will have to:

- Download the ZIP file and uncompress it;
- Rotate the upside down pieces;
- Sort the pieces to reassemble the document;
- Read the token using OCR
- Send the token to retrieve the flag

First of all, we need to flip the pieces which are upside down. Fortunately, the token is not written in the middle of the document. We have to check to position of each letter and if the top of the letter is higher than 688px then we flip the image.

{{< highlight python >}}
token_height = 750
for w in range(0, 10):
    for h in range(650, 750):
        if sum(img.getpixel((w, h))) < 765:
            token_height = min(h, token_height)
            break
if token_height < 688:
    img = img.rotate(180)
{{< /highlight >}}

After few tries, we can notice that some letters does not start at 688px. But there are sentences above and below the token we could use to detect the orientation of the piece. Let say the sentences are 9 pixels high and count the number of black pixels in these 10x9 blocks. The first sentence need to be located between 91px and 100px, the second between 291px and 300px, and so on...

We could check every sentence, but remember we have 10 seconds, so we will check the first, the third and the fifth sentences (totally arbitrary choice, but it's me who decide, right?).

{{< highlight python >}}
sentence_top, sentence_bottom = (0, 0)
for w in range(0, 10):
    for h in range(0, 1400):
        if (91 <= h < 100) or (391 <= h < 400) or (591 <= h < 600):
            sentence_top += min(1, 765-sum(img.getpixel((w, h))))
        if (100 <= h < 109) or (400 <= h < 409) or (600 <= h < 609):
            sentence_bottom += min(1, 765-sum(img.getpixel((w, h))))
if sentence_top < sentence_bottom:
    img = img.rotate(180)
{{< /highlight >}}

Few tries later, we can see that all pieces have the right orientation. The next step is to sort the pieces. First, we need to decide which piece is the first one. If the first column is completely white but the last is not, then the writing of a sentence has started on that piece. It is not 100% accurate due to the token font, but it will do the job.

Once we have the first pieces, we build a trace of the last column. I call a trace the binary representation of a column: if the pixel is white it's a zero, otherwise it's a one. Then, we xor this trace with the trace of the first column of every other pieces. The xored result that has the least 1 is the one that has the best chance to match.

To sort the pieces, we need to compute the traces of first and last columns for each pieces.

{{< highlight python >}}
trace_first, trace_last = (0, 0)
for w in range(0, 10):
    for h in range(0, 1400):
        if w == 0:
            trace_first += pow(2, h) * min(1, 765-sum(img.getpixel((w, h))))
        if w == 9:
            trace_last += pow(2, h) * min(1, 765-sum(img.getpixel((w, h))))
{{< /highlight >}}

The result is not perfect, mostly because it is difficult to find the first piece. With more time, we could build several possibilities for comparison, but we have only 10 seconds. With this approach, we consume 5 to 6 seconds to build the document, and we do not have performed the OCR yet. For this challenge, I decided to deal with these failures: we do not have attempts limit, if we failed with one ZIP file, we can retry.

For the characters recognition, pytesseract do the job pretty well. But due to the token font, the recognition fail every time. To be honest, I had left my script looping a long time before I realize that the OCR is not working as I wanted.

To improve the OCR, we need to keep only uppercase letters and numbers. We can also notice that the token is a hexadecimal string. We could then delete all non-hexadecimal characters but we would miss some letters. We will therefore replace the badly deciphered characters with a similar hexadecimal characters. Thanks to the large number of images previously collected, I was able to observe which characters were often poorly recognized.

{{< highlight python >}}
text = pytesseract.image_to_string(img)
text = re.sub(r'[^0-9A-Z]', '', text.upper())
text = text.replace('O', '0').replace('P', 'F').replace('I', '1').replace('Z', '2').replace('Q', '0').replace('G', '6').replace('S', '5')
{{< /highlight >}}

That's all, we can let our script run until it successfully rebuilds a document and recognizes the token. Personally, it took me twenty attempts before I managed to send the right token and get the flag.

> **Congratz**! The flag is : NDH{H0ly_fr@cking_PONY_!--D3Ath-to-the_0n3_whO-ordered_piZzas-w!th_pineapple_!}

{{< gist vonKrafft 5a918fb30bcb53e7f82ff44e2f0864ab "shreddinger.py" >}}