/*
** 2014 May 31
**
** The author disclaims copyright to this source code.  In place of
** a legal notice, here is a blessing:
**
**    May you do good and not evil.
**    May you find forgiveness for yourself and forgive others.
**    May you share freely, never taking more than you give.
**
******************************************************************************
*/


/* #include "fts5Int.h" */

/**************************************************************************
** Start of asciics tokenizer implementation.
*/

/*
** For tokenizers with no "unicode" modifier, the set of token characters
** is the same as the set of ASCII range alphanumeric characters.
*/
static unsigned char aAsciicsTokenChar[128] = {
  0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,   /* 0x00..0x0F */
  0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,   /* 0x10..0x1F */
  0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,   /* 0x20..0x2F */
  1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 0, 0, 0, 0, 0, 0,   /* 0x30..0x3F */
  0, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 1, 1, 1, 1, 1,   /* 0x40..0x4F */
  1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 0, 0, 0, 0, 0,   /* 0x50..0x5F */
  0, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 1, 1, 1, 1, 1,   /* 0x60..0x6F */
  1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 0, 0, 0, 0, 0,   /* 0x70..0x7F */
};

typedef struct AsciicsTokenizer AsciicsTokenizer;
struct AsciicsTokenizer {
  unsigned char aTokenChar[128];
};

static void fts5AsciicsAddExceptions(
  AsciicsTokenizer *p,
  const char *zArg,
  int bTokenChars
){
  int i;
  for(i=0; zArg[i]; i++){
    if( (zArg[i] & 0x80)==0 ){
      p->aTokenChar[(int)zArg[i]] = (unsigned char)bTokenChars;
    }
  }
}

/*
** Delete a "asciics" tokenizer.
*/
static void fts5AsciicsDelete(Fts5Tokenizer *p){
  sqlite3_free(p);
}

/*
** Create an "asciics" tokenizer.
*/
static int fts5AsciicsCreate(
  void *pUnused,
  const char **azArg, int nArg,
  Fts5Tokenizer **ppOut
){
  int rc = SQLITE_OK;
  AsciicsTokenizer *p = 0;
  UNUSED_PARAM(pUnused);
  if( nArg%2 ){
    rc = SQLITE_ERROR;
  }else{
    p = sqlite3_malloc(sizeof(AsciicsTokenizer));
    if( p==0 ){
      rc = SQLITE_NOMEM;
    }else{
      int i;
      memset(p, 0, sizeof(AsciicsTokenizer));
      memcpy(p->aTokenChar, aAsciicsTokenChar, sizeof(aAsciicsTokenChar));
      for(i=0; rc==SQLITE_OK && i<nArg; i+=2){
        const char *zArg = azArg[i+1];
        if( 0==sqlite3_stricmp(azArg[i], "tokenchars") ){
          fts5AsciicsAddExceptions(p, zArg, 1);
        }else
        if( 0==sqlite3_stricmp(azArg[i], "separators") ){
          fts5AsciicsAddExceptions(p, zArg, 0);
        }else{
          rc = SQLITE_ERROR;
        }
      }
      if( rc!=SQLITE_OK ){
        fts5AsciicsDelete((Fts5Tokenizer*)p);
        p = 0;
      }
    }
  }

  *ppOut = (Fts5Tokenizer*)p;
  return rc;
}


static void asciicsFold(char *aOut, const char *aIn, int nByte){
  int i;
  for(i=0; i<nByte; i++){
    char c = aIn[i];
    if( c>='A' && c<='Z' ) c += 32;
    aOut[i] = c;
  }
}

/*
** Tokenize some text using the asciics tokenizer.
*/
static int fts5AsciicsTokenize(
  Fts5Tokenizer *pTokenizer,
  void *pCtx,
  int iUnused,
  const char *pText, int nText,
  int (*xToken)(void*, int, const char*, int nToken, int iStart, int iEnd)
){
  AsciicsTokenizer *p = (AsciicsTokenizer*)pTokenizer;
  int rc = SQLITE_OK;
  int ie;
  int is = 0;

  char aFold[64];
  int nFold = sizeof(aFold);
  char *pFold = aFold;
  unsigned char *a = p->aTokenChar;

  UNUSED_PARAM(iUnused);

  while( is<nText && rc==SQLITE_OK ){
    int nByte;

    /* Skip any leading divider characters. */
    while( is<nText && ((pText[is]&0x80)==0 && a[(int)pText[is]]==0) ){
      is++;
    }
    if( is==nText ) break;

    /* Count the token characters */
    ie = is+1;
    while( ie<nText && ((pText[ie]&0x80) || a[(int)pText[ie]] ) ){
      ie++;
    }

    /* Fold to lower case */
    nByte = ie-is;
    if( nByte>nFold ){
      if( pFold!=aFold ) sqlite3_free(pFold);
      pFold = sqlite3_malloc64((sqlite3_int64)nByte*2);
      if( pFold==0 ){
        rc = SQLITE_NOMEM;
        break;
      }
      nFold = nByte*2;
    }
    asciicsFold(pFold, &pText[is], nByte);

    /* Invoke the token callback */
    rc = xToken(pCtx, 0, pFold, nByte, is, ie);
    is = ie+1;
  }

  if( pFold!=aFold ) sqlite3_free(pFold);
  if( rc==SQLITE_DONE ) rc = SQLITE_OK;
  return rc;
}
