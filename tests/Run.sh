# #Session Key Server Setup
# cd services
# git clone https://github.com/s-u/SessionKeyServer.git
# cd SessionKeyServer
# sudo make
# cd /home/travis/build/prateeknaik/rcloud/services

# sudo sed -i -e '2iROOT=/home/travis/build/prateeknaik/rcloud\' rcloud-sks
# sudo sh rcloud-sks &

# Rscript -e 'chooseCRANmirror(ind=81)'
# Rscript -e 'install.packages("XML", repos=c("http://RForge.net", "http://R.research.att.com"), type="source")'
# Rscript -e 'install.packages("rcloud.dcplot", repos="http://rforge.net")'
# Rscript -e 'install.packages("rpython2", repos="http://rforge.net")'
# Rscript -e 'install.packages("xml2", repos=c("http://RForge.net", "http://R.research.att.com"), type="source")'

# cd /home/travis/build/prateeknaik/rcloud/tests
# #sudo apt-get install xvfb
# pwd
# echo "Executing testscripts from $1"
# sudo xvfb-run -a casperjs test --ssl-protocol=any --engine=slimerjs $1 --username=iprateek032 --password=musigma12 --url=http://127.0.0.1:8080/login.R --xunit=Reports/report.xml
# Rscript parse.R

# if [ $? -eq 0 ]
# then
#   echo "Build Pass"
# else
#   echo "Build Fail"
# exit 1
# fi



#Session Key Server Setup
cd services
git clone https://github.com/s-u/SessionKeyServer.git
cd SessionKeyServer
sudo make
cd /home/travis/build/prateeknaik/rcloud/services

sudo sed -i -e '2iROOT=/home/travis/build/prateeknaik/rcloud\' rcloud-sks
sudo sh rcloud-sks &

sudo Rscript -e 'chooseCRANmirror(ind=81)'
sudo Rscript -e 'install.packages("XML", repos=c("http://RForge.net", "http://R.research.att.com"), type="source")'
sudo Rscript -e 'install.packages("rcloud.dcplot", repos="http://rforge.net")'
sudo Rscript -e 'install.packages("rpython2", repos="http://rforge.net")'
sudo Rscript -e 'install.packages("xml2", repos=c("http://RForge.net", "http://R.research.att.com"), type="source")'
sudo Rscript -e 'install.packages("drat", repos="https://cran.rstudio.com")'

sudo Rscript -e 'install.packages("devtools", repos="http://RForge.net")'
sudo Rscript -e 'devtools::install_github("hadley/devtools")'

# sudo Rscript -e 'devtools::install_github("att/rcloud.rmd")'
sudo Rscript -e 'install.packages("rcloud.rmd", repos=c("http://RForge.net", "http://R.research.att.com"), type="source")'

# sudo Rscript -e 'devtools::install_github("att/rcloud.shiny")'
sudo Rscript -e 'install.packages("rcloud.shiny", repos=c("http://RForge.net", "http://R.research.att.com"), type="source")'

# sudo Rscript -e 'devtools::install_github("att/rcloud.htmlwidgets")'
sudo Rscript -e 'install.packages("rcloud.htmlwidgets", repos=c("http://RForge.net", "http://R.research.att.com"), type="source")'

# sudo Rscript -e 'devtools::install_github("att/rcloud.flexdashboard")'
sudo Rscript -e 'install.packages("rcloud.flexdashboard", repos=c("http://RForge.net", "http://R.research.att.com"), type="source")'


cd /home/travis/build/prateeknaik/rcloud/tests
# Rscript -e R_dependencies.R
#sudo apt-get install xvfb
pwd
echo "Executing testscripts from $1"
sudo xvfb-run -a casperjs test --ssl-protocol=any --engine=slimerjs --verbose --log-level=debug $1 --username=att-MuSigma --password=musigma12 --url=http://127.0.0.1:8080/login.R --xunit=Reports/report.xml
# sudo xvfb-run -a casperjs test --ssl-protocol=any --engine=slimerjs 2-3Test/*.js --username=prateeknaik --password=musigma12 --url=http://127.0.0.1:8080/login.R --xunit=Reports/report.xml

echo -e "Starting to update AUTO_IMG\n"
# change directory to Travis Home
cd $Home

#Making a new directory in travis home 
mkdir Images
sudo chmod 777 Images
cd Images

#copying file/directory from /home/travis/build/prateeknaik/rcloud/tests to the newly created Images directory
cp -R /home/travis/build/prateeknaik/rcloud/tests/Images/*.png $HOME/Images/
sudo chmod 777 *

#go to travis home directory and configure git
cd $HOME
git config --global user.email "travis@travis-ci.org"
git config --global user.name "travis"


#using token clone the other branch(here its AUTO_IMG) in travis home directory
git clone --quiet --branch=AUTO_IMG https://${GH_TOKEN}@github.com/prateeknaik/rcloud.git  AUTO_IMG > /dev/null

#Go the the newly cloned branch(AUTO_IMG)
cd AUTO_IMG
#Now copy the images from Travis home directory to the newly cloned branch directory
cp -Rf $HOME/Images/* ./tests/Images/

#add, commit and push files to the cloned branch (eg: "AUTO_IMG" branch)
git add -f .
git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to AUTO_IMG"
git push https://prateeknaik:P12345678k@github.com/prateeknaik/rcloud.git AUTO_IMG > /dev/null
# git push -fq origin AUTO_IMG > /dev/null
echo -e "The test images are uploaded \n"

#Changing the directory where parse.R script prsent and run that script
cd /home/travis/build/prateeknaik/rcloud/tests
Rscript parse.R

if [ $? -eq 0 ]
then
  echo "Build Pass"
else
  echo "Build Fail"
exit 1
fi
