#!/bin/sh

while getopts "m" arg; do
  case $arg in
  m)    mobimaker=True;;
  *)    exit 1
  esac
done

WORKING_DIR=/working

if [ $(find "$WORKING_DIR" -name "*.azw3" -or -name "*.epub" | wc -l) -eq 0 ]; then
  echo "There is NEITHER azw3 NOR epub file under $WORKING_DIR"
  echo "Try mounting with $WORKING_DIR in container:"
  echo "  docker run --rm -v <BOOKs Directory>:$WORKING_DIR wangkexiong/kindle"

  exit 0
fi

function conv_epub
{
  mkdir -p /tmp/_epub
  echo "" >> /home/failed
  echo "Convert to EPUB failed:" >> /home/failed

  find $WORKING_DIR -name "*.azw3" -exec /bin/sh -c '
    cp "$0" /tmp/_epub
    cd /tmp/_epub
    PYTHONPATH=/usr/local/bin python3 -m lib.kindleunpack "`basename \"$0\"`"
    find . -name "*.epub" -exec cp {\} "`dirname \"$0\"`" \;
    if [ ! -f "${0%.azw3}.epub" ]; then
      echo "  ${0#/opt/}" >> /home/failed
    fi
    rm -rf /tmp/_epub/*
  ' {} \;

  rm -rf /tmp/_epub
}

function conv_mobi
{
  echo "" >> /home/failed
  echo "Convert to MOBI failed:" >> /home/failed

  find $WORKING_DIR -name "*.epub" -exec /bin/sh -c '
    cp "$0" /tmp/.
    working="`basename \"$0\"`"
    cd /tmp/
    /usr/local/bin/kindlegen "$working"
    if [ -f "${working%.epub}.mobi" ]; then
      /usr/local/bin/kindlestrip.py "${working%.epub}.mobi" "${working%.epub}.mobi"
      cp "${working%.epub}.mobi" "`dirname \"$0\"`"
    else
      echo "  ${0#/opt/}" >> /home/failed
    fi
    rm -rf /tmp/*
  ' {} \;
}

> /home/failed
echo "" >> /home/failed
echo "################################################################################" >> /home/failed

conv_epub
if [ "x$mobimaker" == "xTrue" ]; then
  conv_mobi
fi

echo "" >> /home/failed
echo "################################################################################" >> /home/failed
cat /home/failed

