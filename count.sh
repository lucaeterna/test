#! /bin/bash

count_size_bytes () { #arg1 = directory

  sum=0
  dir="$1"
  for n in $(find $dir -exec stat -c%s {} +); do let "sum+=n" ; done
  echo $sum

}


count_size_kb () { #arg1 = directory

  sum=0
  dir="$1"
  for n in $(find $dir -exec stat -c%b {} +); do let "sum+=n" ; done
  let "sum=sum/2"
  echo $sum

}


count_size () { #arg1 = directory

  sum=0
  dir="$1"
  declare -a arr

  while IFS= read -r -d '' file; do
    h="$(stat -c%h "$file")"
    size="$(stat -c%b "$file")"
    if [[ $h -gt 1 ]]; then 
      i="$(stat -c%i $file)"
      if ! [[ ${arr[$i]} ]]; then
        arr[$i]=1
        let "sum+=size"
      #else
      #  echo "This file has already been counted"
      fi
    else
      let "sum+=size"
    fi
  done < <(find $dir -print0)  

  let "sum=sum/2"
  echo "$sum"

}

$@
