# Bad Template Emulation for C

```c
#define List_F(T) T *items; size_t cap, count
#define List(T) struct { List_F(T); }

#define da_init(xs) \
do { \
  assert((xs)->cap != 0); \
  (xs)->items = malloc((xs)->cap * sizeof((xs)->items[0])); \
} while (0);

#define da_init_ar(arena, xs) \
do { \
  (xs)->items = arena_alloc((arena), (xs)->cap * sizeof((xs)->items[0])); \
} while (0);

#define da_push(xs, x) \
  do { \
    if ((xs)->count >= (xs)->cap) { \
      assert((xs)->cap != 0); \
      (xs)->cap *= 2; \
      (xs)->items = realloc((xs)->items, (xs)->cap*sizeof(*(xs)->items)); \
    } \
\
    (xs)->items[(xs)->count++] = (x); \
  } while (0)

#define da_push_ar(arena, xs, x) \
do { \
  if ((xs)->count >= (xs)->cap) { \
    assert((xs)->cap != 0); \
    (xs)->cap *= 2; \
    (xs)->items = arena_alloc((arena), (xs)->cap)); \
  } \
\
  (xs)->items[(xs)->count++] = (x); \
}

#define da_pop(xs) \
  do { \
    assert ((xs)->count > 0); \
    (xs)->count -= 1; \
  } while (0)

#define da_last(xs) (xs)->items[(xs)->count - 1]
```

Usage:
```c
List(int) a = { .cap = 256, };
da_init(&a);

da_push(&a, 25);
printf("%d\n", da_last(&a));
da_pop(&a);
```

or even
```c
struct {
  // ... whatever
  List_F(int);
} a = { .cap = 256, };
da_init(&a);

da_push(&a, 25)
// ...
```

However, you can't do
```c
void f(List(int) a);
```
because List(int) is an anonymous struct.

To get around this, you can do
```c
typedef List(int) IntList;
void f(IntList a);
```

You can't do
```c
List(List(int)) a;
```
or
```c
List({
  int a, b;
}) a;
```
because they both result in commas in the arguments
of a macro, which get interpreted as argument separators
to the macro.

To get around this, you can do
```c
struct {
  List(int) *items;
  int cap, count;
} a;
```

Of course, this could be used for other data structures.
For example, here is a naive implementation of a pool
data structure.

```c
// count represents width of used region
#define Pool_F(T) T *items; int cap, count; List(int) free_list
#define Pool(T) struct { Pool_F(T); }

#define pool_init(xs) \
  do { \
    (xs)->count = 0; \
    assert((xs)->cap != 0); \
    (xs)->items = malloc((xs)->cap * sizeof((xs)->items[0])); \
    (xs)->free_list.count = 0; \
    if ((xs)->free_list.cap == 0) (xs)->free_list.cap = 256; \
    (xs)->free_list.items = malloc((xs)->free_list.cap * \
                                   sizeof((xs)->free_list.items[0])); \
  } while (0);

#define pool_init_ar(arena, xs) \
  do { \
    (xs)->count = 0; \
    assert((xs)->cap != 0); \
    (xs)->items = arena_alloc((arena), (xs)->cap * sizeof((xs)->items[0])); \
    (xs)->free_list.count = 0; \
    if ((xs)->free_list.cap == 0) (xs)->free_list.cap = 256; \
    (xs)->free_list.items = arena_alloc((arena), (xs)->free_list.cap * \
                                   sizeof((xs)->free_list.items[0])); \
  } while (0);

#define pool_add(xs, x) \
  do { \
    if ((xs)->free_list.count == 0) da_push(xs, x); \
    else { \
      (xs)->items[da_last(&((xs)->free_list))] = x; \
      da_pop(&((xs)->free_list)); \
    } \
  } while(0);

#define pool_add_ar(arena, xs, x) \
  do { \
    if ((xs)->free_list.count == 0) da_push_ar(arena, xs, x); \
    else { \
      (xs)->items[da_last(&((xs)->free_list))] = x; \
      da_pop(&((xs)->free_list)); \
    } \
  } while(0);

#define pool_del(xs, i) da_push(&((xs)->free_list), i)
```
