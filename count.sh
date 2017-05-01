#! /bin/bash



count_size_bytes () { #arg1 = directory
  
  sum=0
  dir=$1
  for n in `find $dir -exec stat -c%s {} \;`; do let "sum+=n" ; done
  echo $sum
}

count_size_kb () { #arg1 = directory
  
  sum=0
  dir=$1
  for n in `find $dir -exec stat -c%b {} \;`; do let "sum+=n" ; done
  let "sum+=sum/2"
  echo $sum
}

count_size () { #arg1 = directory
  
  sum=0
  dir=$1
  declare -a arr

  while IFS= read -r -d '' file; do
    #echo "$file"
    h=`stat -c%h "$file"`
    size=`stat -c%b "$file"`
    #echo "$size"
    if [[ $h -gt 1 ]]; then 
      i=`stat -c%i $file`
      if ! [[ ${arr[$i]} ]]; then
        #echo "This file has been already counted !"
        arr[$i]=1
        let "sum+=size"
      else
        echo "This file was already counted"
        #arr[$i]=1
        #let "sum+=size"
      fi
    else
      let "sum+=size"
    fi
  done < <(find $dir -print0)  
  let "sum=sum/2"
  echo "$sum"

}

$@
