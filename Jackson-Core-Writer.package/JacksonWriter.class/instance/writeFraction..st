writing
writeFraction: fraction

	writeStream
		print: fraction numerator;
		nextPut: $/;
		print: fraction denominator