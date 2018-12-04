indice = 1
while indice < 100:
   otro = True
   if indice % 3 == 0:
      print "fizz"
      otro = False

   if indice %5 == 0:
      print "buzz"
      otro = False

   if otro:
      print indice

   indice = indice + 1
