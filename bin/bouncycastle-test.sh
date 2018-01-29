#!/bin/bash

function bail() {
	echo "$@"
	exit 1
}

echo -e "\e[1m### java\e[0m: $(readlink -f $(which java))"
java -version || bail "Error running java"

echo -e "\e[1m### javac\e[0m: $(readlink -f $(which javac))"
javac -version || bail "Error running javac"

tempdir=$(mktemp -d)

cat <<EOF > ${tempdir}/BouncyTest.java
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.NoSuchPaddingException;

import org.bouncycastle.util.encoders.Base64;

public class BouncyTest {

    public static final String DEFAULT_PROVIDER = "BC";
    public static final String RSA_ALGORITHM = "RSA/NONE/OAEPWithSHA256AndMGF1Padding";

    public static void main(String[] args) {
        int tests = 0;

        tests += testRsaAlgorithm();
        tests += generateSecretAesKey();

        if (tests > 0) {
            System.out.println("[ERROR] " + tests + " test(s) failed");
            System.exit(1);
        } else {
            System.out.println("OK");
            System.exit(0);
        }
    }

    public static int testRsaAlgorithm() {
        System.out.print("Initiating cipher with " + RSA_ALGORITHM + ": ");
        try {
            Cipher.getInstance(RSA_ALGORITHM, DEFAULT_PROVIDER);
            System.out.println("OK");
            return 0;
        } catch (NoSuchAlgorithmException | NoSuchPaddingException | NoSuchProviderException e) {
            System.out.println("ERROR");
            e.printStackTrace(System.err);
            return 1;
        }
    }

    public static int generateSecretAesKey() {
        System.out.print("Initiating AES key: ");

        try {
            KeyGenerator keyGenerator = KeyGenerator.getInstance("AES");
            keyGenerator.init(256);
            keyGenerator.generateKey();
            System.out.println("OK");
            return 0;
        } catch (NoSuchAlgorithmException e) {
            System.out.println("ERROR");
            e.printStackTrace(System.err);
            return 1;
        }
    }
}
EOF

(
    echo -e "\e[1m### compiling and running BouncyTest\e[0m"
    cd ${tempdir}
    javac BouncyTest.java
    java BouncyTest
)
exitcode=$?

rm -r ${tempdir}

exit $exitcode
